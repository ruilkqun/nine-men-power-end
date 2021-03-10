use actix_web::{ web, Responder };
use deadpool_postgres::{ Manager, Pool };


pub async fn get_user(db:web::Data<Pool>) -> impl Responder {
    let mut conn = db.get().await.unwrap();
    let rows = conn.query("select * from admin", &[]).await.unwrap();
    let v:String = rows[0].get("account");
    format!("{}",v)
}