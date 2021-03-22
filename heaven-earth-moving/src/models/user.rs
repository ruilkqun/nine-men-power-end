use serde::{Deserialize,Serialize};
use crate::models::status::Status;



// 获取账户总信息 请求体
#[derive(Deserialize,Debug)]
pub struct UserInfoEntityRequest {
    pub token: String,
    pub account: String
}


// 获取账户总信息 返回体
#[derive(Serialize,Debug)]
pub struct UserInfoEntity {
    pub data: Vec<UserInfoEntityItem>,
    pub count: usize
}

// 获取账户每条信息 返回体
#[derive(Serialize,Debug)]
pub struct UserInfoEntityItem {
    pub user_id: i64,
    pub user_account: String,
    pub user_phone: String,
    pub user_note: String,
    pub user_create_date: String
}


// 创建账户信息 请求体
#[derive(Deserialize,Debug)]
pub struct CreateUserInfoEntity {
    pub user_account: String,
    pub user_password: String,
    pub user_phone: String,
    pub user_note: String
}


// 创建账户信息 返回体
#[derive(Serialize)]
pub struct CreateUserInfoResponseEntity {
    pub result: Status
}


// 删除账户信息 请求体
#[derive(Deserialize,Debug)]
pub struct RemoveUserInfoEntity {
    pub user_id: i64,
    pub user_account: String,
    pub user_phone: String
}


// 删除账户信息 返回体
#[derive(Serialize)]
pub struct RemoveUserInfoResponseEntity {
    pub result: Status
}