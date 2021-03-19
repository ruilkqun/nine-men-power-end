use actix_web::{ web, Responder, Error };
use deadpool_postgres::{ Manager, Pool };
use actix_web::{ get,post };
use actix_web::web::Json;
use tokio_postgres::Row;
use crate::models::article::{ ClassifyInfoEntity,ClassifyInfoEntityItem,CreateClassifyInfoEntity,CreateClassifyInfoResponseEntity,RemoveClassifyInfoEntity,RemoveClassifyInfoResponseEntity,UpdateClassifyInfoEntity,UpdateClassifyInfoResponseEntity,CreateArticleInfoEntity,CreateArticleInfoResponseEntity };
use crate::models::status::Status;
use chrono::prelude::*;
use snowflake::SnowflakeIdGenerator;


#[get("/article/classify_info")]
pub async fn get_classify_info(db:web::Data<Pool>) -> Result<Json<ClassifyInfoEntity>,Error > {
    let mut conn = db.get().await.unwrap();

    let mut classify_info= conn.query("select * from article_classify", &[]).await.unwrap();

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


#[post("/article/create_classify")]
pub async fn create_classify(data:web::Json<CreateClassifyInfoEntity>,db:web::Data<Pool>) -> Result<Json<CreateClassifyInfoResponseEntity>,Error > {
    let mut conn = db.get().await.unwrap();

    let mut id_generator = SnowflakeIdGenerator::new(1,1);
    let mut global_id = id_generator.real_time_generate();

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


#[post("/article/remove_classify")]
pub async fn remove_classify(data:web::Json<RemoveClassifyInfoEntity>,db:web::Data<Pool>) -> Result<Json<RemoveClassifyInfoResponseEntity>,Error > {
    let mut conn = db.get().await.unwrap();

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


#[post("/article/update_classify")]
pub async fn update_classify(data:web::Json<UpdateClassifyInfoEntity>,db:web::Data<Pool>) -> Result<Json<UpdateClassifyInfoResponseEntity>,Error > {
    let mut conn = db.get().await.unwrap();

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


#[post("/article/create_article")]
pub async fn create_article(data:web::Json<CreateArticleInfoEntity>,db:web::Data<Pool>) -> Result<Json<CreateArticleInfoResponseEntity>,Error > {
    let mut conn = db.get().await.unwrap();

    let mut id_generator = SnowflakeIdGenerator::new(1,1);
    let mut global_id = id_generator.real_time_generate();

    let  article_id =  global_id.clone().to_string();
    let  article_account = data.article_account.clone();
    let  article_classify = data.article_classify.clone();
    let  article_title = data.article_title.clone();
    let  article_content = data.article_content.clone();

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


    let insert_result = conn.execute("insert into article(article_id,article_account,article_classify,article_title,article_content) values ($1,$2,$3,$4,$5)", &[&article_id,&article_account,&article_classify,&article_title,&article_content]).await;

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