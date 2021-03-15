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


// 更新 进度信息 请求体
#[derive(Deserialize,Debug)]
pub struct UpdatePlanScheduleEntity {
    pub plan_id: i64,
    pub plan_account: String,
    pub plan_schedule: String
}


// 更新 进度信息 返回体
#[derive(Serialize)]
pub struct UpdatePlanScheduleResponseEntity {
    pub result: Status
}



// 获取 计划执行情况 信息 请求体
#[derive(Deserialize,Debug)]
pub struct StatisticPlanInfoEntityRequest {
    pub statistical_time: String,
}


// 获取 计划执行情况 信息 返回体
#[derive(Serialize,Debug)]
pub struct StatisticPlanInfoEntity {
    pub statistical_time: Vec<StatisticPlanInfoEntityTimeItem>,
    pub statistical_running_count: Vec<StatisticPlanInfoEntityRunItem>,
    pub statistical_completed_count: Vec<StatisticPlanInfoEntityCompletedItem>,
}

// 获取 统计时间 每条信息 返回体
#[derive(Serialize,Debug)]
pub struct StatisticPlanInfoEntityTimeItem {
    pub statistical_time: String,

}

// 获取 统计运行数 每条信息 返回体
#[derive(Serialize,Debug)]
pub struct StatisticPlanInfoEntityRunItem {
    pub statistical_running_count: i64,
}

// 获取 统计完成数 每条信息 返回体
#[derive(Serialize,Debug)]
pub struct StatisticPlanInfoEntityCompletedItem {
    pub statistical_completed_count: i64,
}