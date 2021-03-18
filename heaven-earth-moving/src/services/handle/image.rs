use actix_web::{ web, Responder, Error };
use deadpool_postgres::{ Manager, Pool };
use actix_web::{ get,post };
use actix_web::web::Json;
use tokio_postgres::Row;
use crate::models::image::{ UploadImageEntity,UploadImageResponseEntity };
use crate::models::status::Status;
use chrono::prelude::*;
use snowflake::SnowflakeIdGenerator;

use base64::{encode, decode};
use std::io::prelude::*;
use std::fs::File;
use crate::services::config::BackendConfig;


#[post("/img/upload_img")]
pub async fn upload_img(data:web::Json<UploadImageEntity>, db:web::Data<Pool>) -> Result<Json<UploadImageResponseEntity>,Error >  {
    let mut id_generator = SnowflakeIdGenerator::new(1,1);
    let mut global_id = id_generator.real_time_generate();

    let path = format!("./nginx/static/images/{:?}.png",global_id);
    let base64_data = data.base64data.clone();
    let mut file = File::create(path.clone()).unwrap();
    let write_result = file.write(&decode(base64_data).unwrap()[..]);


    let file_path = "./qiaofeng.toml";
    let mut file = match File::open(file_path) {
        Ok(f) => f,
        Err(e) => panic!("no such file {} exception:{}", file_path, e)
    };

    let mut str_val = String::new();
    match file.read_to_string(&mut str_val) {
        Ok(f) => f,
        Err(e) => panic!("Error Reading file: {}", e)
    };

    let backend_config:BackendConfig = toml::from_str(&str_val).unwrap();
    let mut images_url:String = "".to_string();

    match backend_config.backend_config {
        Some(r) => {
            images_url = match r.images {
                Some(r1) => {
                    r1
                }
                None => {images_url}
            };
        },
        None => ()
    };

    let image_id = format!("{:?}.png",global_id);
    let image_url_path = images_url + &*image_id;

    match write_result {
        Ok(r) => {
            if r > 0 {
                    println!("添加图片成功!");
                    Ok(
                            Json(UploadImageResponseEntity {
                                path: image_url_path,
                                result: Status::SUCCESS,
                        })
                    )
            }else {
                    println!("内容为空!");
                    Ok(
                            Json(UploadImageResponseEntity {
                                path: "".to_string(),
                                result: Status::SUCCESS,
                        })
                    )
            }

        },
        Err(e) => { println!("写入图片失败!失败原因:{:?}",e);
            Ok(
                    Json(UploadImageResponseEntity {
                        path: "".to_string(),
                        result: Status::FAIL,
                })
            )
        },
    }
}