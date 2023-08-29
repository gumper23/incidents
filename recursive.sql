with recursive nums as (
    select 0 as num
    union all 
    select num + 1 as num 
    from nums
    where num < 10
),
dates as (
    select date(now()) - interval num day as incident_date
    from nums
)
select incident_date, count(i.incident_ts) as incident_count
from dates d 
     left outer join incidents i on (d.incident_date = date(i.incident_ts) and i.severity < 3) 
group by incident_date;

with recursive nums as (
    select 0 as num
    union all 
    select num + 1 as num 
    from nums
    where num < 10
),
dates as (
    select date(now()) - interval num day as incident_date
    from nums
)
select incident_date, count(i.incident_ts) as incident_count
from dates d 
     left outer join incidents i on (d.incident_date = date(i.incident_ts)) 
group by incident_date;

select coalesce(sum(case when incident_ts >= now() - interval 5 day then 1 else 0 end), 0) as incidents_last_5_days, coalesce(sum(case when incident_ts >= now() - interval 30 day then 1 else 0 end), 0) as incidents_last_30_days from incidents where incident_ts >= now() - interval 30 day;
select distinct date(incident_ts), sum(1) over (order by date(incident_ts) desc) from incidents;
select date(incident_ts) as incident_date, count(1) as incident_count from incidents group by date(incident_ts) order by date(incident_ts) desc;
