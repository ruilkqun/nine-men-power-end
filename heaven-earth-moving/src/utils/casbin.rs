// use casbin::prelude::*;
//
//
// // 权限管理
// pub fn torch_order_casbin() {
//     let mut e = Enforcer::new("./casbin/rbac_model.conf", "./casbin/rbac_policy.csv").await?;
//     e.enable_log(true);
// }