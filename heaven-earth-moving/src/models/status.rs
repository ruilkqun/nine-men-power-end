use serde::Serialize;
// 状态枚举
#[derive(Serialize)]
pub enum Status {
    SUCCESS,
    FAIL,
}