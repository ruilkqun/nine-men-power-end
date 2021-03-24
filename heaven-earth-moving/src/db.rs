use deadpool_postgres::{ Manager, Pool };
use tokio_postgres::{ Config, NoTls };

use std::fs::File;
use std::io::prelude::*;
use crate::services::config::PostgresqlConfig;

pub async fn create_pg_pool() -> Pool {
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

    let psql_config:PostgresqlConfig = toml::from_str(&str_val).unwrap();

    let mut host:String = "".to_string();
    let mut user:String = "".to_string();
    let mut password:String = "".to_string();
    let mut dbname:String = "".to_string();
    let mut port:u16 = 0;

    match psql_config.postgresql_config {
        Some(r) => {
            host = match r.server {
                Some(r1) => {
                    r1
                }
                None => {host}
            };
            user = match r.user {
                Some(r1) => {
                    r1
                }
                None => {user}
            };
            password = match r.pwd {
                Some(r1) => {
                    r1
                }
                None => {password}
            };
            dbname = match r.db {
                Some(r1) => {
                    r1
                }
                None => {dbname}
            };
            port = match r.port {
                Some(r1) => {
                    r1
                }
                None => {port}
            };
        },
        None => ()
    };

    let mut cfg = Config::new();
    cfg.host(&*host);
    cfg.user(&*user);
    cfg.password(&*password);
    cfg.dbname(&*dbname);
    cfg.port(port);
    let mgr = Manager::new(cfg, NoTls);
    let pool = Pool::new(mgr,100);
    return pool
}