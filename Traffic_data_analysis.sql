create database traffic_DB;

use traffic_db;

create table traffic_data(
location_id varchar(10), 
timestamp datetime, 
state varchar(50),
road_type varchar(50), 
lane_count int,
speed_limit_kmph int, 
has_signal boolean, 
enforcement_level varchar(50),
blackspot_score float, 
latitude float, 
longitude float, 
season varchar(50), 
day_of_week int,
hour_of_day int, 
lighting varchar(50), 
weather varchar(50), 
is_peak boolean, 
vehicle_count_per_hr int,
avg_speed_kmph float, 
peak boolean, 
traffic_data_quality_flag varchar(50), 
signal_status varchar(50),
green_duration_s int, 
red_duration_s int, 
yellow_duration_s int,
cycle_time_s int,
violations_count int, 
signal_data_quality_flag varchar(50),
accident_occurred boolean, 
severity varchar(50), 
vehicles_involved int, 
cause varchar(50),
veh_count_at_accident int);

select * from traffic_data;


# 1. High Risk Locations:

select location_id, avg(blackspot_score) as avg_risk
from traffic_data
group by location_id
order by avg_risk desc
limit 10;

# 2. Peak Accident Hours

select extract(hour from timestamp) as hour,
count(*) as accidents
from traffic_data
where accident_occurred = 'True'
group by hour
order by accidents desc;

# 3. Signal Impact:

select signal_status, count(*) as accidents
from traffic_data
where accident_occurred = 'True'
group by signal_status;

# 4. Cause of accidents
select cause, count(*) as accidents
from traffic_data
where accident_occurred = 'True'
group by cause
order by accidents desc;

# 5. Location wise number of vehicles involved when accident occured 

select location_id, count(vehicles_involved) as total_vehicles_involved
from traffic_data
where accident_occurred = 'True'
group by location_id
order by total_vehicles_involved desc;

# 6. Weather conditions when accident occured

select weather, count(*) as accidents
from traffic_data
where accident_occurred = 'True'
group by weather
order by accidents desc;

# 7. Speed Impact

select
case
	when speed_limit_kmph < 40 then 'Low Speed'
    when speed_limit_kmph between 40 and 70 then 'Medium Speed'
    else 'High Speed'
end as speed_category,
count(*) as accidents
from traffic_data
where accident_occurred = 'True'
group by speed_category;


