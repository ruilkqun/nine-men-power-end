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
    pub user_role: String,
    pub user_phone: String,
    pub user_note: String,
    pub user_create_date: String
}


// 创建账户信息 请求体
#[derive(Deserialize,Debug)]
pub struct CreateUserInfoEntity {
    pub user_account: String,
    pub user_role: String,
    pub user_password: String,
    pub user_phone: String,
    pub user_note: String,
    // 用于创建账号的管理员的token和账户
    pub token: String,
    pub account: String
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
    pub user_phone: String,
    // 用于删除账号的管理员的token和账户
    pub token: String,
    pub account: String
}


// 删除账户信息 返回体
#[derive(Serialize)]
pub struct RemoveUserInfoResponseEntity {
    pub result: Status
}


// 改变账户 角色信息 请求体
#[derive(Deserialize,Debug)]
pub struct ChangeUserRoleInfoEntity {
    pub user_id: i64,
    pub user_account: String,
    pub user_role: String,
    // 用于改变账号角色的管理员的token和账户
    pub token: String,
    pub account: String
}


// 改变账户 角色信息 返回体
#[derive(Serialize)]
pub struct ChangeUserRoleInfoResponseEntity {
    pub result: Status
}


// 改变账户 密码信息 请求体
#[derive(Deserialize,Debug)]
pub struct ChangeUserPasswordRequestEntity {
    pub old_password: String,
    pub new_password: String,
    pub confirm_new_password: String,
    // 用于改变账号密码的管理员的token和账户
    pub token: String,
    pub account: String
}


// 改变账户 密码信息 返回体
#[derive(Serialize)]
pub struct ChangeUserPasswordResponseEntity {
    pub result: Status
}

// 改变账户 手机信息 请求体
#[derive(Deserialize,Debug)]
pub struct ChangeUserPhoneRequestEntity {
    pub old_phone: String,
    pub new_phone: String,
    pub confirm_new_phone: String,
    // 用于改变账号密码的管理员的token和账户
    pub token: String,
    pub account: String
}


// 改变账户 手机信息 返回体
#[derive(Serialize)]
pub struct ChangeUserPhoneResponseEntity {
    pub result: Status
}


// 获取个人信息 请求体
#[derive(Deserialize,Debug)]
pub struct PersonalInfoRequestEntity {
    pub token: String,
    pub account: String
}


// 获取个人信息 返回体
#[derive(Serialize,Debug)]
pub struct PersonalInfoResponseEntity {
    pub account: String,
    pub role: String,
    pub phone: String,
    pub article_count: i64
}
