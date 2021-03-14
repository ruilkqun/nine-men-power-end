use actix_web::{ web, Responder, Error };
use deadpool_postgres::{ Manager, Pool };
use actix_web::{ get,post };
use actix_web::web::Json;
use crate::models::plan::{ PlanInfoEntityRequest,PlanInfoEntity,PlanInfoEntityItem,CreatePlanInfoEntity,CreatePlanInfoResponseEntity };
use crate::models::status::Status;
use chrono::prelude::*;


#[post("/plan/plan_info")]
pub async fn get_plan_info(data:web::Json<PlanInfoEntityRequest>,db:web::Data<Pool>) -> Result<Json<PlanInfoEntity>,Error > {
    let mut conn = db.get().await.unwrap();

    let status = data.status.clone();
    let plan_info = conn.query("select * from plan where status=$1", &[&status]).await.unwrap();

    let mut data = Vec::new();
    let count = plan_info.len();


    for i in 0..count {
        let tmp = PlanInfoEntityItem {
            plan_id: plan_info[i].get("id"),
            plan_account: plan_info[i].get("account"),
            plan_create_date: plan_info[i].get("create_date"),
            plan_completed_date: plan_info[i].get("completed_date"),
            plan_note: plan_info[i].get("note"),
            plan_schedule: plan_info[i].get("schedule"),
        };
        data.push(tmp);
    }

    Ok(Json( PlanInfoEntity {
        data,
        count,
       }
    ))
}



#[post("/plan/create_plan")]
pub async fn create_plan(data:web::Json<CreatePlanInfoEntity>,db:web::Data<Pool>) -> Result<Json<CreatePlanInfoResponseEntity>,Error > {
    let mut conn = db.get().await.unwrap();

    let base_time = Local::now();
    let format_time = base_time.format("%Y-%m-%d %H:%M:%S").to_string();


    let plan_account = data.plan_account.clone();
    let plan_create_date = format_time.clone();
    let plan_completed_date = "".to_string();
    let plan_note = data.plan_note.to_string();
    let plan_schedule = data.plan_schedule.clone();
    let plan_status = data.plan_status.clone();


    let insert_result = conn.execute("insert into plan(account,create_date,completed_date,note,schedule,status) values ($1,$2,$3,$4,$5,$6)", &[&plan_account,&plan_create_date,&plan_completed_date,&plan_note,&plan_schedule,&plan_status]).await;

    match insert_result {
        Ok(_) => { println!("创建计划成功!");
            Ok(
                    Json(CreatePlanInfoResponseEntity {
                    result: Status::SUCCESS,
                })
            )
        },
        Err(e) => { println!("创建计划失败!失败原因:{:?}",e);
            Ok(
                    Json(CreatePlanInfoResponseEntity {
                    result: Status::FAIL,
                })
            )
        },
    }
}