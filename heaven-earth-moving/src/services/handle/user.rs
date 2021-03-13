use actix_web::{ web, Responder, Error };
use deadpool_postgres::{ Manager, Pool };
use actix_web::get;
use actix_web::web::Json;
use crate::models::user::{ UserInfoEntity,UserInfoEntityItem };


#[get("/user")]
pub async fn get_user(db:web::Data<Pool>) -> impl Responder {
    let mut conn = db.get().await.unwrap();
    let rows = conn.query("select * from admin", &[]).await.unwrap();
    let v:String = rows[0].get("account");
    format!("{}",v)
}


#[get("/user_info")]
pub async fn get_user_info(db:web::Data<Pool>) -> Result<Json<UserInfoEntity>,Error > {
    let mut conn = db.get().await.unwrap();
    let user_info = conn.query("select * from admin", &[]).await.unwrap();

    let mut data = Vec::new();
    let count = user_info.len();
    for i in 0..count {
        let tmp = UserInfoEntityItem {
            user_id: user_info[i].get("id"),
            user_account: user_info[i].get("account"),
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



    // let v:String = rows[0].get("account");

}