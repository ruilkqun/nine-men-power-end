pub mod handle;
pub mod config;




pub mod factory {
    use actix_web::dev::HttpServiceFactory;
    use actix_web::web;

    use crate::services::handle::{ login,user,plan,article,image };

    pub fn api_routes() -> impl HttpServiceFactory {
        web::scope("")
            .service(login::login)
            .service(user::get_user)
            .service(user::get_user_info)
            .service(user::create_user)
            .service(user::remove_user)
            .service(user::change_user_role)
            .service(user::change_password)
            .service(user::change_phone)
            .service(user::get_person_info)
            .service(plan::get_plan_info)
            .service(plan::create_plan)
            .service(plan::adjust_schedule)
            .service(plan::statistic_plan)
            .service(plan::statistic_info)
            .service(article::create_classify)
            .service(article::get_classify_info)
            .service(article::remove_classify)
            .service(article::update_classify)
            .service(image::upload_img)
            .service(image::delete_img)
            .service(image::upload_user_img)
            .service(image::get_user_img)
            .service(article::create_article)
            .service(article::get_list_info)
            .service(article::get_article_info)
    }
}