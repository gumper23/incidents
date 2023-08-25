create table if not exists incidents (
    id int unsigned not null auto_increment primary key
    , incident_datetime datetime not null
    , severity tinyint unsigned not null default 3
);

with recursive nums as (
    select 0 as num
    union all 
    select num + 1 as num 
    from nums
    where num < 29
),
dates as (
    select date(now()) - interval num day as incident_date
    from nums
)
select incident_date, count(i.incident_datetime) as incident_count
from dates d 
     left outer join incidents i on (d.incident_date = date(i.incident_datetime) and i.severity < 3) 
group by incident_date;

select coalesce(sum(case when incident_datetime >= now() - interval 5 day then 1 else 0 end), 0) as incidents_last_5_days, coalesce(sum(case when incident_datetime >= now() - interval 30 day then 1 else 0 end), 0) as incidents_last_30_days from incidents where incident_datetime >= now() - interval 30 day;
