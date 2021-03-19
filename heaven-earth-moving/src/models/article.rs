use serde::{Deserialize,Serialize};
use crate::models::status::Status;
use serde_json::Value;

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


// 创建文章 请求体
#[derive(Deserialize,Debug)]
pub struct CreateArticleInfoEntity {
    // pub article_id: String,
    pub article_account: String,
    pub article_classify: String,
    pub article_title: String,
    pub article_content: Value,
    pub article_image: Vec<String>,
    // pub article_create_date: String
}


// 创建文章 返回体
#[derive(Serialize)]
pub struct CreateArticleInfoResponseEntity {
    pub result: Status
}




// 获取文章列表 总信息 返回体
#[derive(Serialize,Debug)]
pub struct ArticleListInfoEntity {
    pub data: Vec<ArticleListInfoEntityItem>,
    pub count: usize
}

// 获取文章列表 每条信息 返回体
#[derive(Serialize,Debug)]
pub struct ArticleListInfoEntityItem {
    pub article_id: String,
    pub article_account: String,
    pub article_classify: String,
    pub article_title: String,
    pub article_create_date: String
}