use actix_web::{ web, Responder,Error };
use deadpool_postgres::{ Manager, Pool };
use crate::models::login::{LoginRequestEntity,LoginResponseEntity};
use crate::utils::jwt::encode_jwt;
use actix_web::web::Json;
use actix_web::post;
use crate::models::status::Status;

#[post("/login")]
pub async fn login(data:web::Json<LoginRequestEntity>,db:web::Data<Pool>) -> Result<Json<LoginResponseEntity>,Error > {
    let mut conn = db.get().await.unwrap();
    let mut name:String = "".to_string();
    let mut pwd:String = "".to_string();

    name = data.account.clone();
    pwd = data.pwd.clone();

    // println!("name:{}",name);
    // println!("pwd:{}",pwd);

    let rows = conn.query("select * from admin where account=$1 and password=$2", &[&name,&pwd]).await.unwrap();

    let login_result = rows.len();
    match login_result {
        1 => Ok(Json(LoginResponseEntity {
            status: Status::SUCCESS,
            code: 200,
            message: "".to_string(),
            data: Some("登陆成功".to_string()),
            token: encode_jwt(name,true),
        })),
        0 => Ok(Json(LoginResponseEntity {
            status: Status::FAIL,
            code: 200,
            message: "登陆失败，请检查用户名或密码".to_string(),
            data: None,
            token: "".to_string(),
        })),
        _ => Ok(Json(LoginResponseEntity {
            status: Status::FAIL,
            code: 200,
            message: "其它错误".to_string(),
            data: None,
            token: "".to_string(),
        }))
    }
}