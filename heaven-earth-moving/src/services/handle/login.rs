use actix_web::{ web,Error };
use deadpool_postgres::Pool;
use crate::models::login::{LoginRequestEntity,LoginResponseEntity};
use crate::utils::jwt::encode_jwt;
use actix_web::web::Json;
use actix_web::post;
use crate::models::status::Status;

use std::sync::RwLock;
use casbin::{Enforcer, CoreApi};

#[post("/login")]
pub async fn login(enforcer:web::Data<RwLock<Enforcer>>,data:web::Json<LoginRequestEntity>,db:web::Data<Pool>) -> Result<Json<LoginResponseEntity>,Error > {
    let conn = db.get().await.unwrap();
    let name:String = data.account.clone();
    let pwd:String = data.pwd.clone();


    // 鉴权
    let sheng_huo_ling = ["admin_role","editor_role","visitor_role"];
    let a = enforcer.clone();
    let e = a.write().unwrap().get_role_manager().write().unwrap().get_roles(&*name, None);
    let mut casbin_flag:bool = false;
    for k in sheng_huo_ling.iter(){
        for v in e.iter(){
            if k == v {
                casbin_flag = true;
            }
        }
    }
    assert_eq!(casbin_flag, true);

    let rows = conn.query("select * from admin where account=$1 and password=$2", &[&name,&pwd]).await.unwrap();
    // let role_rows = conn.query("select * from user_role where account=$1",&[&name]).await.unwrap();
    //
    //
    // let mut roles = Vec::new();
    // let count = role_rows.len();
    //
    //
    // for  i in 0..count {
    //     let role = role_rows[i].get("role");
    //     roles.push(role);
    // }

    let roles = "".to_string();
    let login_result = rows.len();
    match login_result {
        1 => Ok(Json(LoginResponseEntity {
            status: Status::SUCCESS,
            code: 200,
            message: "".to_string(),
            data: Some("登陆成功".to_string()),
            token: encode_jwt(name,true),
            role:rows[0].get("role")
        })),
        0 => Ok(Json(LoginResponseEntity {
            status: Status::FAIL,
            code: 200,
            message: "登陆失败，请检查用户名或密码".to_string(),
            data: None,
            token: "".to_string(),
            role:roles
        })),
        _ => Ok(Json(LoginResponseEntity {
            status: Status::FAIL,
            code: 200,
            message: "其它错误".to_string(),
            data: None,
            token: "".to_string(),
            role:roles
        }))
    }
}