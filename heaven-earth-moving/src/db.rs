use deadpool_postgres::{ Manager, Pool };
use tokio_postgres::{ Config, NoTls };

pub async fn create_pg_pool() -> Pool {
    let mut cfg = Config::new();
    cfg.host("localhost");
    cfg.user("taiji");
    cfg.password("zhangsanfeng");
    cfg.dbname("taiji");
    cfg.port(5432);
    let mgr = Manager::new(cfg, NoTls);
    let pool = Pool::new(mgr,100);
    return pool
}