use md_water_services;

select 
concat(lower(replace(employee_name, ' ', '.')),"@ndogowater.gov") as new_email
from employee;


update employee
set email = concat(lower(replace(employee_name, ' ', '.')),"@ndogowater.gov");

select trim(phone_number), length(trim(phone_number))as phone_length
from employee;

update employee
set phone_number = trim(phone_number);

select town_name, 
count(town_name) as num_of_employees
 from employee
 group by town_name;
 
 select distinct town_name from employee ;
 
 select assigned_employee_id, 
 count(visit_count) as number_of_visits
 from visits
 group by assigned_employee_id
 order by count(visit_count) asc;
 
 select * from visits;
 
 select distinct a.assigned_employee_id, b.employee_name, b.email, b.phone_number, b.position from visits as a, employee as b
 where a.assigned_employee_id = b.assigned_employee_id
 and a.assigned_employee_id in (20,22);
 
 select count(town_name) as records_per_town, town_name from location group by town_name order by count(town_name) desc;
 
  select count(province_name) as records_per_province, province_name from location group by province_name order by count(province_name) desc;
  
   select province_name, town_name, count(town_name) as records_per_town from location group by province_name, town_name order by province_name, count(town_name) desc;
   
   select count(location_type) as num_sources, location_type from location group by location_type;
   
   select ((23740)/(23740 + 15910))*100;
   
   select count(number_of_people_served) as no_of_people_served from water_source;
   
select type_of_water_source, count(number_of_people_served) from water_source group by type_of_water_source;

select type_of_water_source, round(avg(number_of_people_served)) as average_people_per_source from water_source group by type_of_water_source;

select type_of_water_source, round((sum(number_of_people_served)/27628140)*100) as population_served_percentage from water_source group by type_of_water_source order by (sum(number_of_people_served)/27628140)*100 desc;

select sum(number_of_people_served) as population_served from water_source;

 select type_of_water_source, sum(number_of_people_served) as population_served, rank() over(order by sum(number_of_people_served) desc) as ranking from water_source
 where type_of_water_source != 'tap_in_home'
group by type_of_water_source
order by sum(number_of_people_served) desc;

select source_id, type_of_water_source, number_of_people_served,
rank() over (partition by type_of_water_source order by number_of_people_served desc) as priority_rank
from water_source
order by number_of_people_served desc;

select source_id, type_of_water_source, number_of_people_served,
dense_rank() over (partition by type_of_water_source order by number_of_people_served desc) as priority_rank
from water_source
order by number_of_people_served desc;

select min(time_of_record), max(time_of_record) from visits;

select datediff(max(time_of_record),min(time_of_record)) as no_of_days  from visits;


select avg(time_in_queue) from visits where time_in_queue > 0;


select dayname(time_of_record), round(avg(time_in_queue)) from visits where time_in_queue > 0
group by dayname(time_of_record);

select hour(time_of_record) as hour_of_day, round(avg(time_in_queue)) as avg_queue_time from visits where time_in_queue > 0
group by hour(time_of_record)
order by round(avg(time_in_queue)) desc;

select time_format((time_of_record), '%H:00') as hour_of_day, round(avg(time_in_queue)) as avg_queue_time from visits where time_in_queue > 0
group by time_format((time_of_record), '%H:00')
order by round(avg(time_in_queue)) desc;

SELECT
TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
DAYNAME(time_of_record),
CASE
WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
ELSE NULL
END AS Sunday
FROM
visits
WHERE
time_in_queue != 0; 


SELECT
TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
-- Sunday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
ELSE NULL
END
),0) AS Sunday,
-- Monday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Monday' THEN time_in_queue
ELSE NULL
END
),0) AS Monday,
-- Tuesday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Tuesday' THEN time_in_queue
ELSE NULL
END
),0) AS Tuesday,
-- Wednesday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Wednesday' THEN time_in_queue
ELSE NULL
END
),0) AS Wednesday,
-- Thursday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Thursday' THEN time_in_queue
ELSE NULL
END
),0) AS Thursday,
-- Friday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Friday' THEN time_in_queue
ELSE NULL
END
),0) AS Friday,
-- Saturday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Saturday' THEN time_in_queue
ELSE NULL
END
),0) AS Saturday
FROM
visits
WHERE
time_in_queue != 0 -- this excludes other sources with 0 queue times
GROUP BY
hour_of_day
ORDER BY
hour_of_day;


SELECT CONCAT(day(time_of_record), " ", monthname(time_of_record), " ", year(time_of_record)) FROM visits;

SELECT
name,
wat_bas_r - LAG(wat_bas_r) OVER (PARTITION BY name ORDER BY wat_bas_r) 
FROM 
global_water_access
ORDER BY
name;

SELECT
name,
wat_bas_r - LAG(wat_bas_r) OVER (PARTITION BY year ORDER BY name) 
FROM 
global_water_access
ORDER BY
name;

SELECT
name,
wat_bas_r, year
FROM 
global_water_access
ORDER BY
name;


SELECT
type_of_water_source,
SUM(number_of_people_served) AS population_served
FROM
water_source
GROUP BY
type_of_water_source
HAVING type_of_water_source LIKE "%tap%"
ORDER BY
population_served DESC;


