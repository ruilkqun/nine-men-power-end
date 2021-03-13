use actix_web::{ web, Responder, Error };
use deadpool_postgres::{ Manager, Pool };
use actix_web::{ get,post };
use actix_web::web::Json;
use crate::models::user::{ UserInfoEntity,UserInfoEntityItem,CreateUserInfoResponseEntity,CreateUserInfoEntity,RemoveUserInfoEntity,RemoveUserInfoResponseEntity };
use crate::models::status::Status;
use chrono::prelude::*;
use crypto::md5::Md5;
use crypto::digest::Digest;


#[get("/user")]
pub async fn get_user(db:web::Data<Pool>) -> impl Responder {
    let mut conn = db.get().await.unwrap();
    let rows = conn.query("select * from admin", &[]).await.unwrap();
    let v:String = rows[0].get("account");
    format!("{}",v)
}


#[get("/user/user_info")]
pub async fn get_user_info(db:web::Data<Pool>) -> Result<Json<UserInfoEntity>,Error > {
    let mut conn = db.get().await.unwrap();
    let user_info = conn.query("select * from admin", &[]).await.unwrap();

    let mut data = Vec::new();
    let count = user_info.len();
    for i in 0..count {
        let tmp = UserInfoEntityItem {
            user_id: user_info[i].get("id"),
            user_account: user_info[i].get("account"),
            user_phone: user_info[i].get("phone"),
            user_note: user_info[i].get("note"),
            user_create_date: user_info[i].get("create_date"),
        };
        data.push(tmp);
    }

    Ok(Json( UserInfoEntity {
        data,
        count,
       }
    ))
}


#[post("/user/create_user")]
pub async fn create_user(data:web::Json<CreateUserInfoEntity>,db:web::Data<Pool>) -> Result<Json<CreateUserInfoResponseEntity>,Error > {
    let mut conn = db.get().await.unwrap();

    let base_time = Local::now();
    let format_time = base_time.format("%Y-%m-%d %H:%M:%S").to_string();

    let mut md5 = Md5::new();
    md5.input_str(&*data.user_password.clone());
    let password = md5.result_str();

    let user_account = data.user_account.clone();
    let user_password = password.clone();
    let user_phone = data.user_phone.clone();
    let user_note = data.user_note.clone();
    let user_create_date = format_time.clone();

    let insert_result = conn.execute("insert into admin(account,password,phone,note,create_date) values ($1,$2,$3,$4,$5)", &[&user_account,&user_password,&user_phone,&user_note,&user_create_date]).await;

    match insert_result {
        Ok(_) => { println!("创建用户成功!");
            Ok(
                    Json(CreateUserInfoResponseEntity {
                    result: Status::SUCCESS,
                })
            )
        },
        Err(e) => { println!("创建用户失败!失败原因:{:?}",e);
            Ok(
                    Json(CreateUserInfoResponseEntity {
                    result: Status::FAIL,
                })
            )
        },
    }
}


#[post("/user/remove_user")]
pub async fn remove_user(data:web::Json<RemoveUserInfoEntity>,db:web::Data<Pool>) -> Result<Json<RemoveUserInfoResponseEntity>,Error > {
    let mut conn = db.get().await.unwrap();

    let user_id = data.user_id.clone();
    let user_account = data.user_account.clone();
    let user_phone = data.user_phone.clone();

    println!("user_account:{:?}",user_account);

    let remove_result = conn.execute("delete from admin where id=$1 and account=$2 and phone=$3", &[&user_id,&user_account,&user_phone]).await;

    match remove_result {
        Ok(_) => { println!("删除用户成功!");
            Ok(
                    Json(RemoveUserInfoResponseEntity {
                    result: Status::SUCCESS,
                })
            )
        },
        Err(e) => { println!("删除用户失败!失败原因:{:?}",e);
            Ok(
                    Json(RemoveUserInfoResponseEntity {
                    result: Status::FAIL,
                })
            )
        },
    }
}