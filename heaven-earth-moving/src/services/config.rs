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