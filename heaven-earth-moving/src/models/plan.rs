use serde::{Deserialize,Serialize};
use crate::models::status::Status;


// 获取计划总信息 请求体
#[derive(Deserialize,Debug)]
pub struct PlanInfoEntityRequest {
    pub status: String,
}


// 获取计划总信息 返回体
#[derive(Serialize,Debug)]
pub struct PlanInfoEntity {
    pub data: Vec<PlanInfoEntityItem>,
    pub count: usize
}

// 获取计划每条信息 返回体
#[derive(Serialize,Debug)]
pub struct PlanInfoEntityItem {
    pub plan_id: i64,
    pub plan_account: String,
    pub plan_create_date: String,
    pub plan_completed_date: String,
    pub plan_note: String,
    pub plan_schedule: String
}



// 创建计划信息 请求体
#[derive(Deserialize,Debug)]
pub struct CreatePlanInfoEntity {
    pub plan_account: String,
    pub plan_note: String,
    pub plan_schedule: String,
    pub plan_status: String
}


// 创建计划信息 返回体
#[derive(Serialize)]
pub struct CreatePlanInfoResponseEntity {
    pub result: Status
}