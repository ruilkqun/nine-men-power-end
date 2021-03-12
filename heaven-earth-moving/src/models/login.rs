use serde::{Deserialize,Serialize};
use crate::models::status::Status;


#[derive(Deserialize,Debug)]
pub struct LoginRequestEntity {
    pub account: String,
    pub pwd: String,
}


#[derive(Serialize)]
pub struct LoginResponseEntity {
    pub status: Status,
    pub code: i64,
    pub message: String,
    pub data: Option<String>,
    pub token: String,
}