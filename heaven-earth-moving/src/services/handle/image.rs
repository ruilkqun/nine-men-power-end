use actix_web::{ web, Error };
use deadpool_postgres::Pool;
use actix_web::post;
use actix_web::web::Json;
use crate::models::image::{ UploadImageEntity,UploadImageResponseEntity,DeleteImageEntity,DeleteImageResponseEntity,UploadUserImageEntity,UploadUserImageResponseEntity,GetUserImageEntity,GetUserImageResponseEntity };
use crate::models::status::Status;
use snowflake::SnowflakeIdGenerator;

use base64::decode;
use std::io::prelude::*;
use std::fs::File;
use std::fs;
use crate::services::config::BackendConfig;


use std::sync::RwLock;
use casbin::{Enforcer, CoreApi};
use std::io::Read;

use crate::utils::jwt::decode_jwt;


#[post("/img/upload_img")]
pub async fn upload_img(data:web::Json<UploadImageEntity>) -> Result<Json<UploadImageResponseEntity>,Error >  {
    let mut id_generator = SnowflakeIdGenerator::new(1,1);
    let global_id = id_generator.real_time_generate();

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
                                image_id: global_id.clone().to_string(),
                                result: Status::SUCCESS,
                        })
                    )
            }else {
                    println!("内容为空!");
                    Ok(
                            Json(UploadImageResponseEntity {
                                path: "".to_string(),
                                image_id: "".to_string(),
                                result: Status::SUCCESS,
                        })
                    )
            }

        },
        Err(e) => { println!("写入图片失败!失败原因:{:?}",e);
            Ok(
                    Json(UploadImageResponseEntity {
                        path: "".to_string(),
                        image_id: "".to_string(),
                        result: Status::FAIL,
                })
            )
        },
    }
}



#[post("/img/delete_img")]
pub async fn delete_img(data:web::Json<DeleteImageEntity>) -> Result<Json<DeleteImageResponseEntity>,Error >  {
    let global_id = data.image_id.clone();
    let path = format!("./nginx/static/images/{}.png",global_id);

    println!("path:{:?}",path);
    fs::remove_file(path).unwrap();

    Ok(
        Json(DeleteImageResponseEntity {
            result: Status::SUCCESS,
        })
    )
}


// 上传用户头像
#[post("/img/upload_user_img")]
pub async fn upload_user_img(enforcer:web::Data<RwLock<Enforcer>>,data:web::Json<UploadUserImageEntity>,db:web::Data<Pool>) -> Result<Json<UploadUserImageResponseEntity>,Error >  {
    let account:String = data.account.clone();
    let token:String = data.token.clone();


    // 认证
    let jwt_flag = decode_jwt(token);
    assert_eq!(jwt_flag, true);
    // 鉴权
    let sheng_huo_ling = ["admin_role","editor_role","visitor_role"];
    let a = enforcer.clone();
    let e = a.write().unwrap().get_role_manager().write().unwrap().get_roles(&*account, None);
    let mut casbin_flag:bool = false;
    for k in sheng_huo_ling.iter(){
        for v in e.iter(){
            if k == v {
                casbin_flag = true;
            }
        }
    }
    assert_eq!(casbin_flag, true);


    let mut id_generator = SnowflakeIdGenerator::new(1,1);
    let global_id = id_generator.real_time_generate();

    // 放入新的头像
    let path = format!("./nginx/static/images/{:?}.png",global_id);
    let base64_data = data.base64data.clone();
    let mut file = File::create(path.clone()).unwrap();
    let write_result = file.write(&decode(base64_data).unwrap()[..]);

    let conn = db.get().await.unwrap();
    // 删除之前头像
    let user_image_info = conn.query("select * from user_image_id where account=$1", &[&account]).await.unwrap();
    if user_image_info.len() > 0 {
        let id:i64 = user_image_info[0].get("image_id");
        let path = format!("./nginx/static/images/{}.png",id);
        println!("path:{:?}",path);
        fs::remove_file(path).unwrap();
    }
    // 更新user_image信息
    conn.execute("insert into user_image_id(account,image_id) values ($1,$2) on conflict(account) do update set image_id=$2", &[&account,&global_id]).await.unwrap();


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
                            Json(UploadUserImageResponseEntity {
                                path: image_url_path,
                                result: Status::SUCCESS,
                        })
                    )
            }else {
                    println!("内容为空!");
                    Ok(
                            Json(UploadUserImageResponseEntity {
                                path: "".to_string(),
                                result: Status::SUCCESS,
                        })
                    )
            }

        },
        Err(e) => { println!("写入图片失败!失败原因:{:?}",e);
            Ok(
                    Json(UploadUserImageResponseEntity {
                        path: "".to_string(),
                        result: Status::FAIL,
                })
            )
        },
    }
}


// 获取用户头像
#[post("/img/get_user_img")]
pub async fn get_user_img(enforcer:web::Data<RwLock<Enforcer>>,data:web::Json<GetUserImageEntity>,db:web::Data<Pool>) -> Result<Json<GetUserImageResponseEntity>,Error > {
    let account: String = data.account.clone();
    let token: String = data.token.clone();


    // 认证
    let jwt_flag = decode_jwt(token);
    assert_eq!(jwt_flag, true);
    // 鉴权
    let sheng_huo_ling = ["admin_role", "editor_role", "visitor_role"];
    let a = enforcer.clone();
    let e = a.write().unwrap().get_role_manager().write().unwrap().get_roles(&*account, None);
    let mut casbin_flag: bool = false;
    for k in sheng_huo_ling.iter() {
        for v in e.iter() {
            if k == v {
                casbin_flag = true;
            }
        }
    }
    assert_eq!(casbin_flag, true);


    let conn = db.get().await.unwrap();
    // 获取头像 对象 镜像ID
    let user_image_info = conn.query("select * from user_image_id where account=$1", &[&account]).await.unwrap();
    let mut image_id:i64 = 0;
    if user_image_info.len() > 0 {
        image_id = user_image_info[0].get("image_id");
    }

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

    let backend_config: BackendConfig = toml::from_str(&str_val).unwrap();
    let mut images_url: String = "".to_string();

    match backend_config.backend_config {
        Some(r) => {
            images_url = match r.images {
                Some(r1) => {
                    r1
                }
                None => { images_url }
            };
        },
        None => ()
    };

    let id = format!("{}",image_id);
    let image_url_path = images_url + &*id +".png";

    Ok(Json(GetUserImageResponseEntity {
        path: image_url_path,
        result: Status::SUCCESS,
    }))
}