use serde::{Deserialize,Serialize};
use crate::models::status::Status;



// 创建上传图片 请求体
#[derive(Deserialize,Debug)]
pub struct UploadImageEntity {
    pub base64data: String,
}


// 创建上传图片信息 返回体
#[derive(Serialize)]
pub struct UploadImageResponseEntity {
    pub path:String,
    pub image_id: String,
    pub result: Status
}


// 创建删除图片 请求体
#[derive(Deserialize,Debug)]
pub struct DeleteImageEntity {
    pub image_id: String
}


// 创建删除图片信息 返回体
#[derive(Serialize)]
pub struct DeleteImageResponseEntity {
    pub result: Status
}
