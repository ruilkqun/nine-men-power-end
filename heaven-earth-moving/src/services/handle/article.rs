use actix_web::{ web, Error };
use deadpool_postgres::Pool;
use actix_web::post;
use actix_web::web::Json;
use crate::models::article::{ ClassifyInfoRequestEntity,ClassifyInfoEntity,ClassifyInfoEntityItem,CreateClassifyInfoEntity,CreateClassifyInfoResponseEntity,RemoveClassifyInfoEntity,RemoveClassifyInfoResponseEntity,UpdateClassifyInfoEntity,UpdateClassifyInfoResponseEntity,CreateArticleInfoEntity,CreateArticleInfoResponseEntity,ArticleListInfoEntity,ArticleListInfoRequestEntity,ArticleListInfoEntityItem,ArticleInfoEntityRequest,ArticleInfoEntityResponse };
use crate::models::status::Status;
use chrono::prelude::*;
use snowflake::SnowflakeIdGenerator;
use std::sync::RwLock;
use casbin::{Enforcer, CoreApi};
use crate::utils::jwt::decode_jwt;

// 获取 文章分类
#[post("/article/classify_info")]
pub async fn get_classify_info(enforcer:web::Data<RwLock<Enforcer>>,data:web::Json<ClassifyInfoRequestEntity>,db:web::Data<Pool>) -> Result<Json<ClassifyInfoEntity>,Error > {
    let  account:String = data.account.clone();
    let  token:String = data.token.clone();


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

    let classify_info= conn.query("select * from article_classify", &[]).await.unwrap();

    let mut data = Vec::new();
    let count = classify_info.len();


    for i in 0..count {
        let tmp = ClassifyInfoEntityItem {
            classify_id: classify_info[i].get("classify_id"),
            classify_name: classify_info[i].get("classify_name")
        };
        data.push(tmp);
    }

    Ok(Json( ClassifyInfoEntity {
        data,
        count,
       }
    ))
}

// 创建 文章分类
#[post("/article/create_classify")]
pub async fn create_classify(enforcer:web::Data<RwLock<Enforcer>>,data:web::Json<CreateClassifyInfoEntity>,db:web::Data<Pool>) -> Result<Json<CreateClassifyInfoResponseEntity>,Error > {
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

    let mut id_generator = SnowflakeIdGenerator::new(1,1);
    let global_id = id_generator.real_time_generate();

    let  classify_id =  global_id.clone().to_string();
    let  classify_name = data.classify_name.clone();

    let insert_result = conn.execute("insert into article_classify(classify_id,classify_name) values ($1,$2)", &[&classify_id,&classify_name]).await;

    match insert_result {
        Ok(_) => { println!("创建分类成功!");
            Ok(
                    Json(CreateClassifyInfoResponseEntity {
                    result: Status::SUCCESS,
                })
            )
        },
        Err(e) => { println!("创建分类失败!失败原因:{:?}",e);
            Ok(
                    Json(CreateClassifyInfoResponseEntity {
                    result: Status::FAIL,
                })
            )
        },
    }
}


// 移除 文章 分类
#[post("/article/remove_classify")]
pub async fn remove_classify(enforcer:web::Data<RwLock<Enforcer>>,data:web::Json<RemoveClassifyInfoEntity>,db:web::Data<Pool>) -> Result<Json<RemoveClassifyInfoResponseEntity>,Error > {
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

    let  classify_id = data.classify_id.clone();

    let remove_result = conn.execute("delete from article_classify where classify_id=$1", &[&classify_id]).await;

    match remove_result {
        Ok(_) => { println!("删除分类成功!");
            Ok(
                    Json(RemoveClassifyInfoResponseEntity {
                    result: Status::SUCCESS,
                })
            )
        },
        Err(e) => { println!("删除分类失败!失败原因:{:?}",e);
            Ok(
                    Json(RemoveClassifyInfoResponseEntity {
                    result: Status::FAIL,
                })
            )
        },
    }
}


// 更新文章分类
#[post("/article/update_classify")]
pub async fn update_classify(enforcer:web::Data<RwLock<Enforcer>>,data:web::Json<UpdateClassifyInfoEntity>,db:web::Data<Pool>) -> Result<Json<UpdateClassifyInfoResponseEntity>,Error > {
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

    let  classify_name = data.classify_name.clone();
    let  classify_id = data.classify_id.clone();

    let update_result = conn.execute("update article_classify set classify_name=$2 where classify_id=$1", &[&classify_id,&classify_name]).await;

    match update_result {
        Ok(_) => { println!("删除分类成功!");
            Ok(
                    Json(UpdateClassifyInfoResponseEntity {
                    result: Status::SUCCESS,
                })
            )
        },
        Err(e) => { println!("删除分类失败!失败原因:{:?}",e);
            Ok(
                    Json(UpdateClassifyInfoResponseEntity {
                    result: Status::FAIL,
                })
            )
        },
    }
}


// 创建文章内容
#[post("/article/create_article")]
pub async fn create_article(enforcer:web::Data<RwLock<Enforcer>>,data:web::Json<CreateArticleInfoEntity>,db:web::Data<Pool>) -> Result<Json<CreateArticleInfoResponseEntity>,Error > {
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

    let mut id_generator = SnowflakeIdGenerator::new(1,1);
    let global_id = id_generator.real_time_generate();

    let  article_id =  global_id.clone().to_string();
    let  article_account = data.article_account.clone();
    let  article_classify = data.article_classify.clone();
    let  article_title = data.article_title.clone();
    let  article_content = data.article_content.clone();
    let article_create_date = format_time.clone();

    let  image_id = data.article_image.clone();

    for v in image_id {
        let insert_image_result = conn.execute("insert into image_id(article_id,article_image_id) values ($1,$2)", &[&article_id,&v]).await;
        match insert_image_result {
            Ok(_) => {
                continue
            },
            Err(e) => {
                println!("创建文章失败!失败原因:{:?}",e);
                return Ok(
                        Json(CreateArticleInfoResponseEntity {
                        result: Status::FAIL,
                    })
                )
            },
        }
    }


    let insert_result = conn.execute("insert into article(article_id,article_account,article_classify,article_title,article_content,article_create_date) values ($1,$2,$3,$4,$5,$6) on conflict (article_account,article_title) do update set article_classify=$3,article_title=$4,article_content=$5", &[&article_id,&article_account,&article_classify,&article_title,&article_content,&article_create_date]).await;

    match insert_result {
        Ok(_) => { println!("创建文章成功!");
            Ok(
                    Json(CreateArticleInfoResponseEntity {
                    result: Status::SUCCESS,
                })
            )
        },
        Err(e) => { println!("创建文章失败!失败原因:{:?}",e);
            Ok(
                    Json(CreateArticleInfoResponseEntity {
                    result: Status::FAIL,
                })
            )
        },
    }
}

// 获取文章列表信息
#[post("/article/list_info")]
pub async fn get_list_info(enforcer:web::Data<RwLock<Enforcer>>,data:web::Json<ArticleListInfoRequestEntity>,db:web::Data<Pool>) -> Result<Json<ArticleListInfoEntity>,Error > {
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

    let list_info= conn.query("select * from article where article_account=$1", &[&account]).await.unwrap();

    let mut data = Vec::new();
    let count = list_info.len();


    for i in 0..count {
        let tmp = ArticleListInfoEntityItem {
            article_id: list_info[i].get("article_id"),
            article_account: list_info[i].get("article_account"),
            article_classify: list_info[i].get("article_classify"),
            article_title: list_info[i].get("article_title"),
            article_create_date: list_info[i].get("article_create_date")
        };
        data.push(tmp);
    }

    Ok(Json( ArticleListInfoEntity {
        data,
        count,
       }
    ))
}

// 获取文章内容
#[post("/article/article_info")]
pub async fn get_article_info(enforcer:web::Data<RwLock<Enforcer>>,data:web::Json<ArticleInfoEntityRequest>,db:web::Data<Pool>) -> Result<Json<ArticleInfoEntityResponse>,Error > {
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
    let article_id = data.article_id.clone();
    let article_title = data.article_title.clone();

    // article_id和article_title 全局唯一，最多一条返回
    let article_info= conn.query("select * from article where article_id=$1 or article_title=$2", &[&article_id,&article_title]).await.unwrap();
    let article_content = article_info[0].get("article_content");


    Ok(Json( ArticleInfoEntityResponse {
        article_content
       }
    ))
}