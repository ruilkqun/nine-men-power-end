#[macro_use]
use delay_timer::prelude::*;

use delay_timer::entity::DelayTimerBuilder;
use chrono::prelude::*;
use delay_timer::timer::task::TaskBuilder;

use curl::easy::Easy;


enum AuspiciousTime {
    PerOneHour,
}

impl Into<CandyCronStr> for AuspiciousTime {
    fn into(self) -> CandyCronStr {
        match self {
            Self::PerOneHour => CandyCronStr("0 0/30 * * * * *".to_string()),
        }
    }
}


pub fn statistic_plan_count() {
    let mut easy = Easy::new();
    easy.url("http://127.0.0.1:9000/plan/statistic_plan").unwrap();
    easy.perform().unwrap();
    println!("{}", easy.response_code().unwrap());
}


pub fn schedule_statistic_plan() {
    let timer = DelayTimerBuilder::default().build();
    let body1 = create_async_fn_body!({
         statistic_plan_count();
    });

    let task1 = TaskBuilder::default()
        .set_frequency_by_candy(CandyFrequency::Repeated(AuspiciousTime::PerOneHour))
        .set_task_id(1)
        .set_maximum_running_time(6)
        .set_maximun_parallel_runable_num(6)
        .spawn(body1)
        .unwrap();

    timer.add_task(task1).unwrap();
}
