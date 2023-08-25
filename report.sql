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
select incident_date, count(i.incident_ts) as incident_count
from dates d 
     left outer join incidents i on (d.incident_date = date(i.incident_ts) and i.severity < 3) 
group by incident_date;

select coalesce(sum(case when incident_ts >= now() - interval 5 day then 1 else 0 end), 0) as incidents_last_5_days, coalesce(sum(case when incident_ts >= now() - interval 30 day then 1 else 0 end), 0) as incidents_last_30_days from incidents where incident_ts >= now() - interval 30 day;

-- incident_date todays_incidents incidents_5_days incidents_30_days
select
    date(incident_ts) as incident_date
    , coalesce(sum(case when date(incident_ts) = current_date() then 1 else 0 end), 0) as todays_incidents
    , coalesce(sum(case when incident_ts >= now() - interval 5 day then 1 else 0 end), 0) as incidents_5_days
    , coalesce(sum(case when incident_ts >= now() - interval 30 day then 1 else 0 end), 0) as incidents_30_days
from
    incidents
group by 
    date(incident_ts)
order by
    date(incident_ts) desc;

