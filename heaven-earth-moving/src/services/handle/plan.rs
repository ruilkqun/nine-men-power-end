use actix_web::{ web, Responder, Error };
use deadpool_postgres::{ Manager, Pool };
use actix_web::{ get,post };
use actix_web::web::Json;
use tokio_postgres::Row;
use crate::models::plan::{ PlanInfoEntityRequest,PlanInfoEntity,PlanInfoEntityItem,CreatePlanInfoEntity,CreatePlanInfoResponseEntity,UpdatePlanScheduleEntity,UpdatePlanScheduleResponseEntity,
StatisticPlanInfoEntityRequest,StatisticPlanInfoEntity,StatisticPlanInfoEntityTimeItem,StatisticPlanInfoEntityRunItem,StatisticPlanInfoEntityCompletedItem};
use crate::models::status::Status;
use chrono::prelude::*;

use std::sync::RwLock;
use casbin::{Enforcer, CoreApi};
use std::io::Read;

use crate::utils::jwt::decode_jwt;

// 获取计划plan信息
#[post("/plan/plan_info")]
pub async fn get_plan_info(enforcer:web::Data<RwLock<Enforcer>>,data:web::Json<PlanInfoEntityRequest>,db:web::Data<Pool>) -> Result<Json<PlanInfoEntity>,Error > {
    let mut account:String = "".to_string();
    let mut token:String = "".to_string();

    account = data.account.clone();
    token = data.token.clone();

    // 认证
    let jwt_flag = decode_jwt(token);
    assert_eq!(jwt_flag, true);
    // 鉴权
    let sheng_huo_ling = ["admin_role","editor_role","visitor_role"];
    let a = enforcer.clone();
    let mut e = a.write().unwrap().get_role_manager().write().unwrap().get_roles(&*account, None);
    let mut casbin_flag:bool = false;
    for k in sheng_huo_ling.iter(){
        for v in e.iter(){
            if k == v {
                casbin_flag = true;
            }
        }
    }
    assert_eq!(casbin_flag, true);

    let mut conn = db.get().await.unwrap();

    let status = data.status.clone();

    let mut plan_info= conn.query("select * from plan", &[]).await.unwrap();

    if status == "".to_string() {
            plan_info = conn.query("select * from plan where account=$1 and status=\'进行中\'", &[&account]).await.unwrap();
    } else {
        let tmp = status.split(',');
        for v in tmp {
            if v == "全选" {
                plan_info = conn.query("select * from plan where account=$1", &[&account]).await.unwrap();
                break;
            } else {
                plan_info = conn.query("select * from plan where account=$1 and status=$2", &[&account,&v]).await.unwrap();
                break;
            }
        }
    }
    println!("status:{:?}",status);


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


// 创建计划plan
#[post("/plan/create_plan")]
pub async fn create_plan(enforcer:web::Data<RwLock<Enforcer>>,data:web::Json<CreatePlanInfoEntity>,db:web::Data<Pool>) -> Result<Json<CreatePlanInfoResponseEntity>,Error > {
    let mut account:String = "".to_string();
    let mut token:String = "".to_string();

    account = data.account.clone();
    token = data.token.clone();

    // 认证
    let jwt_flag = decode_jwt(token);
    assert_eq!(jwt_flag, true);
    // 鉴权
    let sheng_huo_ling = ["admin_role","editor_role","visitor_role"];
    let a = enforcer.clone();
    let mut e = a.write().unwrap().get_role_manager().write().unwrap().get_roles(&*account, None);
    let mut casbin_flag:bool = false;
    for k in sheng_huo_ling.iter(){
        for v in e.iter(){
            if k == v {
                casbin_flag = true;
            }
        }
    }
    assert_eq!(casbin_flag, true);

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


// 调整进度
#[post("/plan/adjust_schedule")]
pub async fn adjust_schedule(enforcer:web::Data<RwLock<Enforcer>>,data:web::Json<UpdatePlanScheduleEntity>,db:web::Data<Pool>) -> Result<Json<UpdatePlanScheduleResponseEntity>,Error > {
    let mut account:String = "".to_string();
    let mut token:String = "".to_string();

    account = data.account.clone();
    token = data.token.clone();

    // 认证
    let jwt_flag = decode_jwt(token);
    assert_eq!(jwt_flag, true);
    // 鉴权
    let sheng_huo_ling = ["admin_role","editor_role","visitor_role"];
    let a = enforcer.clone();
    let mut e = a.write().unwrap().get_role_manager().write().unwrap().get_roles(&*account, None);
    let mut casbin_flag:bool = false;
    for k in sheng_huo_ling.iter(){
        for v in e.iter(){
            if k == v {
                casbin_flag = true;
            }
        }
    }
    assert_eq!(casbin_flag, true);

    let mut conn = db.get().await.unwrap();

    let base_time = Local::now();
    let format_time = base_time.format("%Y-%m-%d %H:%M:%S").to_string();

    let plan_id = data.plan_id.clone();
    let plan_account = data.plan_account.clone();
    let plan_schedule = data.plan_schedule.clone();
    let update_result:Result<u64,tokio_postgres::error::Error>;

    // println!("plan_schedule:{:?}",plan_schedule);

    if plan_schedule != "100%".to_string() {
            update_result = conn.execute("update plan set schedule=$1 where id=$2 and account=$3", &[&plan_schedule,&plan_id,&plan_account]).await;
    } else {
            update_result = conn.execute("update plan set schedule=$1,status='已完成',completed_date=$2 where id=$3 and account=$4", &[&plan_schedule,&format_time,&plan_id,&plan_account]).await;
    }

    match update_result {
        Ok(_) => { println!("更新计划进度成功!");
            Ok(
                    Json(UpdatePlanScheduleResponseEntity {
                    result: Status::SUCCESS,
                })
            )
        },
        Err(e) => { println!("更新计划进度失败!失败原因:{:?}",e);
            Ok(
                    Json(UpdatePlanScheduleResponseEntity {
                    result: Status::FAIL,
                })
            )
        },
    }
}


// 定时任务 统计接口
#[get("/plan/statistic_plan")]
pub async fn statistic_plan(db:web::Data<Pool>) -> impl Responder {
    let base_time = Local::now();
    let scheduler_time = base_time.format("%Y-%m-%d %H:%M:%S").to_string();
    println!("Begin Statistic Plan Count {}",scheduler_time);
    let mut conn = db.get().await.unwrap();

    let mut statistic_running:i64 = 0;
    let mut statistic_completed:i64 = 0;

    let statistic_running_result = conn.query("select count(status) from plan where status='进行中'", &[]).await.unwrap();
    let statistic_completed_result = conn.query("select count(status) from plan where status='已完成'", &[]).await.unwrap();

    if statistic_running_result.len() != 0 {
        statistic_running = statistic_running_result[0].get("count");
    }

    if statistic_completed_result.len() != 0 {
        statistic_completed = statistic_completed_result[0].get("count");
    }

    let insert_statistic_result = conn.execute("insert into plan_statistic(statistical_time,statistical_running_count,statistical_completed_count) values ($1,$2,$3) on conflict(statistical_time) do update set statistical_running_count=$2,statistical_completed_count=$3", &[&scheduler_time,&statistic_running,&statistic_completed]).await;


    match insert_statistic_result {
        Ok(_) => {
            format!("统计数据成功!")
        },
        Err(e) => {
            format!("统计数据失败!失败原因:{:?}",e)
        }
    }
}


// 获取计划plan统计信息
#[post("/plan/statistic_info")]
pub async fn statistic_info(enforcer:web::Data<RwLock<Enforcer>>,data:web::Json<StatisticPlanInfoEntityRequest>,db:web::Data<Pool>) -> Result<Json<StatisticPlanInfoEntity>,Error > {
    let mut account:String = "".to_string();
    let mut token:String = "".to_string();

    account = data.account.clone();
    token = data.token.clone();

    // 认证
    let jwt_flag = decode_jwt(token);
    assert_eq!(jwt_flag, true);
    // 鉴权
    let sheng_huo_ling = ["admin_role","editor_role","visitor_role"];
    let a = enforcer.clone();
    let mut e = a.write().unwrap().get_role_manager().write().unwrap().get_roles(&*account, None);
    let mut casbin_flag:bool = false;
    for k in sheng_huo_ling.iter(){
        for v in e.iter(){
            if k == v {
                casbin_flag = true;
            }
        }
    }
    assert_eq!(casbin_flag, true);

    let mut conn = db.get().await.unwrap();

    let statistical_time = data.statistical_time.clone();

    let tmp = statistical_time.split(',');
    let mut tmp_vec = Vec::new();

    for i in tmp {
        tmp_vec.push(i);
    }

    let begin_tmp = match tmp_vec.get_mut(0){
        Some(r) => r,
        None => ""
    };
    let end_tmp = match tmp_vec.get_mut(1){
        Some(r) => r,
        None => ""
    };
    let mut begin_tmp1 = "";
    if begin_tmp != "" {
        let tmp = begin_tmp.split(' ');
        let mut tmp_vec = Vec::new();
        for v in tmp {
            tmp_vec.push(v);
        }
        begin_tmp1 = match tmp_vec.get_mut(0){
            Some(r) => r,
            None => ""
        };
    }

    let mut end_tmp1 = "";
    if end_tmp != "" {
        let tmp = end_tmp.split(' ');
        let mut tmp_vec = Vec::new();
        for v in tmp {
            tmp_vec.push(v);
        }
        end_tmp1 = match tmp_vec.get_mut(0){
            Some(r) => r,
            None => ""
        };
    }

    /// 最初设想 入库时间精度为天 即%Y-%m-%d,故计算到begin_tmp1，end_tmp1
    println!("begin_tmp1:{:?}",begin_tmp1);
    println!("end_tmp1:{:?}",end_tmp1);

    /// 最终计划 入库时间精度为秒 即%Y-%m-%d %H:%M:%S，故取begin_tmp，end_tmp即可
    let statistic_info = conn.query("select * from plan_statistic where statistical_time >= $1 and statistical_time <= $2 order by statistical_time asc", &[&begin_tmp,&end_tmp]).await.unwrap();


    let mut data_statistical_time = Vec::new();
    let mut data_statistical_running_count = Vec::new();
    let mut data_statistical_completed_count = Vec::new();

    let count = statistic_info.len();
    for i in 0..count {
        let tmp_statistical_time = StatisticPlanInfoEntityTimeItem {
            statistical_time: statistic_info[i].get("statistical_time")
        };
        data_statistical_time.push(tmp_statistical_time);

        let tmp_statistical_running_count = StatisticPlanInfoEntityRunItem {
            statistical_running_count: statistic_info[i].get("statistical_running_count")
        };
        data_statistical_running_count.push(tmp_statistical_running_count);

        let tmp_statistical_completed_count = StatisticPlanInfoEntityCompletedItem {
            statistical_completed_count: statistic_info[i].get("statistical_completed_count")
        };
        data_statistical_completed_count.push(tmp_statistical_completed_count);
    }

    Ok(Json( StatisticPlanInfoEntity {
        statistical_time:data_statistical_time,
        statistical_running_count:data_statistical_running_count,
        statistical_completed_count:data_statistical_completed_count
       }
    ))
}