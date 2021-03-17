pub mod handle;
pub mod config;




pub mod factory {
    use actix_web::dev::HttpServiceFactory;
    use actix_web::web;

    use crate::services::handle::{ login,user,plan,article };

    pub fn api_routes() -> impl HttpServiceFactory {
        web::scope("")
            .service(login::login)
            .service(user::get_user)
            .service(user::get_user_info)
            .service(user::create_user)
            .service(user::remove_user)
            .service(plan::get_plan_info)
            .service(plan::create_plan)
            .service(plan::adjust_schedule)
            .service(plan::statistic_plan)
            .service(plan::statistic_info)
            .service(article::create_classify)
            .service(article::get_classify_info)
            .service(article::remove_classify)
            .service(article::update_classify)
    }
}