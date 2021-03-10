pub mod db;
pub mod services;

use actix_web::{ web,App,HttpServer };
use actix_web::middleware::Logger;
use actix_web::rt::System;
use env_logger::Env;
use chrono::Local;
use std::thread;
use std::io::Write;
use db::create_pg_pool;

use services::handle::user::get_user;


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

    let pool = create_pg_pool().await;


    HttpServer::new( move || {
        App::new().data(pool.clone())
            .route("user",web::get().to(get_user))
            .wrap(Logger::default())
            .wrap(Logger::new("%a %{User-Agent}i"))
    }).bind("127.0.0.1:9000")?.run().await
}
