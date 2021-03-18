use serde::Deserialize;


#[derive(Deserialize,Debug)]
pub struct ActixWebConfig {
    pub actix_web_config: Option<ActixWebConfigItem>,
}


#[derive(Deserialize,Debug)]
pub struct ActixWebConfigItem {
    pub server: Option<String>,
    pub port: Option<u16>,
}


#[derive(Deserialize,Debug)]
pub struct PostgresqlConfig {
    pub postgresql_config: Option<PostgresqlConfigItem>,
}


#[derive(Deserialize,Debug)]
pub struct PostgresqlConfigItem {
    pub server: Option<String>,
    pub port: Option<u16>,
    pub user: Option<String>,
    pub pwd: Option<String>,
    pub db: Option<String>,
}


#[derive(Deserialize,Debug)]
pub struct BackendConfig {
    pub backend_config: Option<BackendConfigItem>,
}


#[derive(Deserialize,Debug)]
pub struct BackendConfigItem {
    pub host: Option<String>,
    pub port: Option<u16>,
    pub nginx_host: Option<String>,
    pub nginx_port: Option<u16>,
    pub images: Option<String>,
}