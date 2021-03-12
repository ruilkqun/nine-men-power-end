#[macro_use]
extern crate log;
extern crate env_logger;

pub mod db;
pub mod services;
pub mod utils;
pub mod models;

use actix_web::{ web,App,HttpServer };
use actix_web::middleware::Logger;
use actix_web::rt::System;
use actix_cors::Cors;

use toml::value::*;
use std::fs::File;
use std::io::prelude::*;
use crate::services::config::ActixWebConfig;


use actix_casbin_auth::casbin::{ DefaultModel, FileAdapter, Result };
use actix_casbin_auth::CasbinService;
use actix_casbin_auth::casbin::function_map::key_match2;
use diesel_adapter::DieselAdapter;

use env_logger::Env;
use chrono::Local;
use std::thread;
use std::io::Write;
use db::create_pg_pool;

use services::handle::user::get_user;
use services::handle::login::login;

use services::factory::api_routes;


use tokio::task;


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


    // let m = DefaultModel::from_file("rbac_model.conf").await.unwrap();
    // let a = FileAdapter::new("rbac_policy.csv");  //You can also use diesel-adapter or sqlx-adapter
    // // let a = DieselAdapter::new("postgres://taiji:zhangsanfeng@localhost:5432/taiji",8)?;
    // let casbin_middleware = CasbinService::new(m,a).await?;

    // casbin_middleware
    //     .write()
    //     .await
    //     .get_role_manager()
    //     .write()
    //     .unwrap()
    //     .matching_fn(Some(key_match2), None);


    let pool = create_pg_pool().await;

    let local = task::LocalSet::new();
    local.run_until(async move {
        task::spawn_local(async move {
            HttpServer::new(move || {
            App::new()
                .data(pool.clone())
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
