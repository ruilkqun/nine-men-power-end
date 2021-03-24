#[macro_use]
extern crate log;
extern crate env_logger;

pub mod db;
pub mod services;
pub mod utils;
pub mod models;
use actix_web::{ web,App,HttpServer };
use actix_web::middleware::Logger;
use actix_cors::Cors;
use std::fs::File;
use std::io::prelude::*;
use crate::services::config::ActixWebConfig;

use env_logger::Env;
use chrono::Local;
use std::io::Write;
use db::create_pg_pool;
use tokio::task;
use services::factory::api_routes;
use crate::utils::delay_statistical_plan_count::schedule_statistic_plan;

use casbin::prelude::*;
use casbin::{DefaultModel, Enforcer, FileAdapter};
use std::sync::RwLock;


#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let env = Env::default().default_filter_or("info");
    env_logger::Builder::from_env(env)
        .format(|buf, record| {
            writeln!(
                buf,
                "{:<5} {} [{}:{}] {}",
                Local::now().format("%Y-%m-%d %H:%M:%S"),
                record.level(),
                record.module_path().unwrap_or("<unnamed>"),
                record.line().unwrap_or(0),
                &record.args()
            )
        })
        .init();

    schedule_statistic_plan();

    let file_path = "./qiaofeng.toml";
    let mut file = match File::open(file_path) {
        Ok(f) => f,
        Err(e) => panic!("no such file {} exception:{}", file_path, e)
    };

    let mut str_val = String::new();
    match file.read_to_string(&mut str_val) {
        Ok(f) => f,
        Err(e) => panic!("Error Reading file: {}", e)
    };

    let actix_web_config:ActixWebConfig = toml::from_str(&str_val).unwrap();

    let mut web_host:String = "".to_string();
    let mut web_port:u16 = 0;

    match actix_web_config.actix_web_config {
        Some(r) => {
            web_host = match r.server {
                Some(r1) => {
                    r1
                }
                None => {web_host}
            };
            web_port = match r.port {
                Some(r1) => {
                    r1
                }
                None => {web_port}
            };
        },
        None => ()
    };


    let model = DefaultModel::from_file("./casbin/rbac_model.conf")
        .await
        .unwrap();
    let adapter = FileAdapter::new("./casbin/rbac_policy.csv");

    let e = Enforcer::new(model,adapter)
        .await
        .unwrap();
    let e = web::Data::new(RwLock::new(e)); // wrap enforcer into actix-state


    let pool = create_pg_pool().await;

    let local = task::LocalSet::new();
    local.run_until(async move {
        task::spawn_local(async move {
            HttpServer::new(move || {
            App::new()
                .data(pool.clone())
                .data(web::PayloadConfig::new(1 << 25))
                .data(web::JsonConfig::default().limit(1024 * 1024 * 50))
                .app_data(e.clone())
                .wrap(
                    Cors::default()
                        .allow_any_header()
                        .allow_any_method()
                        .allow_any_origin())
                .service(api_routes())
                // .route("user",web::get().to(get_user))
                // .route("login",web::post().to(login))
                .wrap(Logger::default())
                .wrap(Logger::new("%a %{User-Agent}i"))
        })
        .bind((format!("{}",web_host.clone()),format!("{}",web_port.clone()).parse::<u16>().unwrap_or(10000)))
        .unwrap()
        .run().await.unwrap();
        }).await.unwrap();
    }).await;

    Ok(())
}
