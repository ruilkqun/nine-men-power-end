use serde::{Deserialize,Serialize};
use crate::models::status::Status;


// 获取文章分类 总信息 返回体
#[derive(Serialize,Debug)]
pub struct ClassifyInfoEntity {
    pub data: Vec<ClassifyInfoEntityItem>,
    pub count: usize
}

// 获取文章分类每条信息 返回体
#[derive(Serialize,Debug)]
pub struct ClassifyInfoEntityItem {
    pub classify_id: String,
    pub classify_name: String,
}


// 创建分类信息 请求体
#[derive(Deserialize,Debug)]
pub struct CreateClassifyInfoEntity {
    pub classify_name: String,
}


// 创建分类信息 返回体
#[derive(Serialize)]
pub struct CreateClassifyInfoResponseEntity {
    pub result: Status
}


// 删除分类信息 请求体
#[derive(Deserialize,Debug)]
pub struct RemoveClassifyInfoEntity {
    pub classify_id: String,
}


// 删除分类信息 返回体
#[derive(Serialize)]
pub struct RemoveClassifyInfoResponseEntity {
    pub result: Status
}


// 更新分类信息 请求体
#[derive(Deserialize,Debug)]
pub struct UpdateClassifyInfoEntity {
    pub classify_id: String,
    pub classify_name: String,
}


// 更新分类信息 返回体
#[derive(Serialize)]
pub struct UpdateClassifyInfoResponseEntity {
    pub result: Status
}