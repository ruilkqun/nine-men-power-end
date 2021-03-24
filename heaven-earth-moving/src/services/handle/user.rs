use actix_web::{ web, Responder, Error };
use deadpool_postgres::Pool;
use actix_web::{ get,post,put };
use actix_web::web::Json;
use crate::models::user::{ UserInfoEntity,UserInfoEntityItem,CreateUserInfoResponseEntity,CreateUserInfoEntity,RemoveUserInfoEntity,RemoveUserInfoResponseEntity,UserInfoEntityRequest,ChangeUserRoleInfoEntity,ChangeUserRoleInfoResponseEntity,ChangeUserPasswordRequestEntity,ChangeUserPasswordResponseEntity,ChangeUserPhoneRequestEntity,ChangeUserPhoneResponseEntity,PersonalInfoRequestEntity,PersonalInfoResponseEntity };
use crate::models::status::Status;
use chrono::prelude::*;
use crypto::md5::Md5;
use crypto::digest::Digest;
use std::sync::RwLock;
use casbin::{Enforcer, CoreApi};
use crate::utils::jwt::decode_jwt;


#[get("/user")]
pub async fn get_user(db:web::Data<Pool>) -> impl Responder {
    let conn = db.get().await.unwrap();
    let rows = conn.query("select * from admin", &[]).await.unwrap();
    let v:String = rows[0].get("account");
    format!("{}",v)
}

// 获取 账户信息
#[post("/user/user_info")]
pub async fn get_user_info(enforcer:web::Data<RwLock<Enforcer>>,data:web::Json<UserInfoEntityRequest>,db:web::Data<Pool>) -> Result<Json<UserInfoEntity>,Error > {
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


    let conn = db.get().await.unwrap();
    let user_info = conn.query("select * from admin", &[]).await.unwrap();

    let mut data = Vec::new();
    let count = user_info.len();
    for i in 0..count {
        let tmp = UserInfoEntityItem {
            user_id: user_info[i].get("id"),
            user_account: user_info[i].get("account"),
            user_role: user_info[i].get("role"),
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



// 创建账户
#[post("/user/create_user")]
pub async fn create_user(enforcer:web::Data<RwLock<Enforcer>>,data:web::Json<CreateUserInfoEntity>,db:web::Data<Pool>) -> Result<Json<CreateUserInfoResponseEntity>,Error > {
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

    let conn = db.get().await.unwrap();

    let base_time = Local::now();
    let format_time = base_time.format("%Y-%m-%d %H:%M:%S").to_string();

    let mut md5 = Md5::new();
    md5.input_str(&*data.user_password.clone());
    let password = md5.result_str();

    let user_account = data.user_account.clone();
    let user_role = data.user_role.clone();
    let user_password = password.clone();
    let user_phone = data.user_phone.clone();
    let user_note = data.user_note.clone();
    let user_create_date = format_time.clone();


    let mut role = "".to_string();
    if user_role == "".to_string() {
            role = "visitor_role".to_string();
    } else {
        let tmp = user_role.split(',');
        for v in tmp {
            if v == "全选" {
                role = "admin_role,editor_role,visitor_role".to_string();
                break;
            } else {
                role = format!("{}",user_role);
                break;
            }
        }
    }


    let insert_result = conn.execute("insert into admin(account,password,phone,note,create_date,role) values ($1,$2,$3,$4,$5,$6)", &[&user_account,&user_password,&user_phone,&user_note,&user_create_date,&role]).await;

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


// 删除账户
#[post("/user/remove_user")]
pub async fn remove_user(enforcer:web::Data<RwLock<Enforcer>>,data:web::Json<RemoveUserInfoEntity>,db:web::Data<Pool>) -> Result<Json<RemoveUserInfoResponseEntity>,Error > {
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

    let conn = db.get().await.unwrap();

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



#[put("/user/change_account_role")]
pub async fn change_user_role(enforcer:web::Data<RwLock<Enforcer>>,data:web::Json<ChangeUserRoleInfoEntity>,db:web::Data<Pool>) -> Result<Json<ChangeUserRoleInfoResponseEntity>,Error > {
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

    let conn = db.get().await.unwrap();

    let user_id = data.user_id.clone();
    let user_account = data.user_account.clone();
    let user_role = data.user_role.clone();


    let mut role = "".to_string();
    let tmp = user_role.split(',');
    for v in tmp {
        if v == "全选" {
            role = "admin_role,editor_role,visitor_role".to_string();
            break;
        } else {
            role = format!("{}",user_role);
            break;
        }
    }


    let change_result = conn.execute("update  admin set role=$1 where id=$2 and account=$3", &[&role,&user_id,&user_account]).await;

    match change_result {
        Ok(_) => { println!("更新账户角色成功!");
            Ok(
                    Json(ChangeUserRoleInfoResponseEntity {
                    result: Status::SUCCESS,
                })
            )
        },
        Err(e) => { println!("更新账户角色失败!失败原因:{:?}",e);
            Ok(
                    Json(ChangeUserRoleInfoResponseEntity {
                    result: Status::FAIL,
                })
            )
        },
    }
}


// 改变账户密码
#[put("/user/change_password")]
pub async fn change_password(enforcer:web::Data<RwLock<Enforcer>>,data:web::Json<ChangeUserPasswordRequestEntity>,db:web::Data<Pool>) -> Result<Json<ChangeUserPasswordResponseEntity>,Error > {
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

    let conn = db.get().await.unwrap();

    let old_password = data.old_password.clone();
    let new_password = data.new_password.clone();
    let confirm_new_password = data.confirm_new_password.clone();

    let mut md5 = Md5::new();
    md5.input_str(&*old_password);
    let password = md5.result_str();

    let mut md5_new = Md5::new();
    md5_new.input_str(&*new_password);
    let new_password_md5 = md5_new.result_str();

    let query_password_result = conn.query("select * from admin where password=$1", &[&password]).await.unwrap();


    if query_password_result.len() > 0 && new_password.clone() == confirm_new_password.clone(){
        let insert_result = conn.execute("update admin set password=$1 where account=$2", &[&new_password_md5,&account]).await;

        match insert_result {
            Ok(_) => { println!("更改密码成功!");
                Ok(
                        Json(ChangeUserPasswordResponseEntity {
                        result: Status::SUCCESS,
                    })
                )
            },
            Err(e) => { println!("更改密码失败!失败原因:{:?}",e);
                Ok(
                        Json(ChangeUserPasswordResponseEntity {
                        result: Status::FAIL,
                    })
                )
            },
        }
    } else {
        Ok(
                Json(ChangeUserPasswordResponseEntity {
                result: Status::FAIL,
            })
        )
    }
}


// 改变账户手机
#[put("/user/change_phone")]
pub async fn change_phone(enforcer:web::Data<RwLock<Enforcer>>,data:web::Json<ChangeUserPhoneRequestEntity>,db:web::Data<Pool>) -> Result<Json<ChangeUserPhoneResponseEntity>,Error > {
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

    let conn = db.get().await.unwrap();

    let old_phone = data.old_phone.clone();
    let new_phone = data.new_phone.clone();
    let confirm_new_phone = data.confirm_new_phone.clone();

    let query_phone_result = conn.query("select * from admin where phone=$1", &[&old_phone]).await.unwrap();


    if query_phone_result.len() > 0 && new_phone.clone() == confirm_new_phone.clone(){
        let insert_result = conn.execute("update admin set phone=$1 where account=$2", &[&new_phone,&account]).await;

        match insert_result {
            Ok(_) => { println!("更改密码成功!");
                Ok(
                        Json(ChangeUserPhoneResponseEntity {
                        result: Status::SUCCESS,
                    })
                )
            },
            Err(e) => { println!("更改密码失败!失败原因:{:?}",e);
                Ok(
                        Json(ChangeUserPhoneResponseEntity {
                        result: Status::FAIL,
                    })
                )
            },
        }
    } else {
        Ok(
                Json(ChangeUserPhoneResponseEntity {
                result: Status::FAIL,
            })
        )
    }
}


// 获取 个人信息
#[post("/user/personal_info")]
pub async fn get_person_info(enforcer:web::Data<RwLock<Enforcer>>,data:web::Json<PersonalInfoRequestEntity>,db:web::Data<Pool>) -> Result<Json<PersonalInfoResponseEntity>,Error > {
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


    let conn = db.get().await.unwrap();
    let account_info = conn.query("select * from admin where account=$1", &[&account]).await.unwrap();

    let article_info = conn.query("select count(*) from article where article_account=$1", &[&account]).await.unwrap();

    let data = PersonalInfoResponseEntity {
        account: account_info[0].get("account"),
        role: account_info[0].get("role"),
        phone: account_info[0].get("phone"),
        article_count: article_info[0].get("count")
    };

    Ok(Json(
        data
    ))
}