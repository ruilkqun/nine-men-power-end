use serde::{Deserialize,Serialize};
use crate::models::status::Status;



// 创建上传图片 请求体
#[derive(Deserialize,Debug)]
pub struct UploadImageEntity {
    pub base64data: String,
}


// 创建分类信息 返回体
#[derive(Serialize)]
pub struct UploadImageResponseEntity {
    pub path:String,
    pub result: Status
}
