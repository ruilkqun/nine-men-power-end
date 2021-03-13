use serde::{Deserialize,Serialize};

#[derive(Serialize,Debug)]
pub struct UserInfoEntity {
    pub data: Vec<UserInfoEntityItem>,
    pub count: usize
}


#[derive(Serialize,Debug)]
pub struct UserInfoEntityItem {
    pub user_id: i64,
    pub user_account: String,
    pub user_phone: String,
    pub user_note: String,
    pub user_create_date: String
}