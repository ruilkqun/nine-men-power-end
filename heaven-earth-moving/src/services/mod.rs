pub mod handle;
pub mod config;




pub mod factory {
    use actix_web::dev::HttpServiceFactory;
    use actix_web::web;

    use crate::services::handle::{ login,user };

    pub fn api_routes() -> impl HttpServiceFactory {
        web::scope("")
            .service(login::login)
            .service(user::get_user)
    }
}