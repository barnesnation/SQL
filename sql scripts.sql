use united_nations;

/*Create TABLE
	Country_List1

as

(SELECT distinct(Country_name) FROM access_to_basic_services);

*/
	
select 
	count(*) as no_of_observations,
    min(Time_period) as min_time_period,
    max(Time_period) as Max_Time_Period,
    count(distinct Country_name) as no_of_countries,
    avg(Pct_managed_drinking_water_services) as avg_man_drinking_water_services
from
	access_to_basic_services;
    
select 
	Country_name,
    Time_period,
    round(Est_gdp_in_billions) as rounded_est_gdp_in_billions,
    log(Est_gdp_in_billions) as log_Est_gdp_in_billions,
    sqrt(Est_gdp_in_billions) as sqrt_Est_gdp_in_billions
from
	access_to_basic_services;
    
    
    
Select 
	Region,
    Sub_region,
    min(Pct_managed_drinking_water_services) as Min_Pct_managed_drinking_water_services,
    max(Pct_managed_drinking_water_services) as max_Pct_managed_drinking_water_services,
    avg(Pct_managed_drinking_water_services) as avg_Pct_managed_drinking_water_services,
    count(distinct Country_name) as no_of_countries,
    sum(Est_gdp_in_billions) as est_total_gdp_in_billions
from
	access_to_basic_services
where Time_period = 2020 and Pct_managed_drinking_water_services <60
group by Region, Sub_region
having no_of_countries < 4
order by est_total_gdp_in_billions asc;


SELECT
 Region,
 Sub_region,
 RANK() OVER (
 ORDER BY Region) AS Rank_assign
FROM
 access_to_basic_services
ORDER BY
 Region;


select Sub_region, Country_name, Land_area,
round(Land_area/sum(Land_area) over (partition by Sub_region)*100) as pct_sub_reg_land_area
	from 
access_to_basic_services
where Time_period = 2020 and Land_area is not null;

select Country_name, Time_period, Pct_managed_drinking_water_services,
rank() over (partition by Time_period order by Pct_managed_drinking_water_services) as rank_of_water_services
from access_to_basic_services;

select Country_name, Time_period, Pct_managed_drinking_water_services,
lag(Pct_managed_drinking_water_services) over (partition by Country_name order by Time_period) as Prev_year_pct_managed_drinking_water,
Pct_managed_drinking_water_services - lag(Pct_managed_drinking_water_services) over (partition by Country_name order by Time_period) as arc_pct_managed_drinking_water
from access_to_basic_services;

select Sub_region, Country_name, Time_period, Est_population_in_millions,
round(avg(Est_population_in_millions) over (partition by Sub_region order by Time_period),4) as running_avg_population
	from 
access_to_basic_services
where Est_population_in_millions is not null;

select distinct
	Country_name,Time_period,Est_population_in_millions,
    cast(Est_population_in_millions as decimal(6,2)) as new_est_pop_in_millions
from
	access_to_basic_services;
    
select distinct country_name, length(country_name) as string_len_country_name,
position("(" in country_name) as position_of_bracket, left(country_name, position("(" in country_name)-2) as New_Country_name,
length(left(country_name, position("(" in country_name)-2))
from 
	access_to_basic_services
where country_name like '%(%';

select distinct Country_name, Time_period, Est_population_in_millions,
concat(LEFT(ifnull(UPPER(Country_name), "UNKNOWN"),4),
LEFT(ifnull(Time_period, "UNKNOWN"),4),
RIGHT(ifnull(Est_population_in_millions,"UNKNOWN"),7)) as Country_id
from
	access_to_basic_services;
    
select 
case when Country_name in ('Kazakhstan', 'Kyrgyzstan', 'Tajikistan')
then "STAN"
WHEN Country_name IN ('Ghana','Nigeria','Burkina Faso', 'Togo')
then 'ECOWAS'
ELSE "UNCLASSIFIED"
END AS COUNTRY_GRPS,
MIN(Pct_managed_drinking_water_services) AS MIN_DRINK,
MAX(Pct_managed_drinking_water_services) AS MAX_DRINK,
AVG(Pct_managed_drinking_water_services) AS AVG_DRINK
from access_to_basic_services
GROUP BY case when Country_name in ('Kazakhstan', 'Kyrgyzstan', 'Tajikistan')
then "STAN"
WHEN Country_name IN ('Ghana','Nigeria','Burkina Faso', 'Togo')
then 'ECOWAS'
ELSE "UNCLASSIFIED"
END;


select Region, Pct_unemployment,
if((Region = 'Central and Southern Asia') and (Pct_unemployment is null), 19.59,
if((Region = 'Eastern and South-Eastern Asia') and (Pct_unemployment is null), 22.64,
if((Region = 'Europe and Northern America') and (Pct_unemployment is null), 24.43,
if((Region = 'Latin America and the Caribbean') and (Pct_unemployment is null), 24.23,
if((Region = 'Northern Africa and Western Asia') and (Pct_unemployment is null), 17.84,
if((Region = 'Oceania') and (Pct_unemployment is null), 4.98,
if((Region = 'Sub-Saharan Africa') and (Pct_unemployment is null), 33.65,
Pct_unemployment ))))))) as new_pct_unemployment
 from access_to_basic_services;
 
 Select distinct 
 Country_name,Time_period,Est_population_in_millions,Est_gdp_in_billions,
 (Est_gdp_in_billions/Est_population_in_millions)*1000 as GDP_PER_CAPITA,
 ((Est_gdp_in_billions/Est_population_in_millions)*1000)/365 AS GDP_PER_CAPITA_PER_DAY,
 if(Time_period<2017,1.90,2.50) as Poverty_Line,
 case when  (((Est_gdp_in_billions/Est_population_in_millions)*1000)/365) < if(Time_period<2017,1.90,2.50)
 then "Low"
 when  (((Est_gdp_in_billions/Est_population_in_millions)*1000)/365) > if(Time_period<2017,1.90,2.50)
 then "High" 
 else "Medium"
 end as Income_Group
 from access_to_basic_services where Est_gdp_in_billions is not null;
 
 
 CREATE TABLE united_nations.Geographic_Location (
  Country_name VARCHAR(37) PRIMARY KEY,
  Sub_region VARCHAR(25),
  Region VARCHAR(32),
  Land_area NUMERIC(10,2));
  
  INSERT INTO united_nations.Geographic_Location (Country_name, Sub_region,Region, Land_area)
SELECT Country_name
	  ,Sub_region
      ,Region
      ,AVG(Land_area) as Country_area
FROM united_nations.Access_to_Basic_Services
GROUP BY Country_name
		,Sub_region
		,Region;


CREATE TABLE united_nations.Economic_Indicators (
  Country_name VARCHAR(37),
  Time_period INTEGER,
  Est_gdp_in_billions NUMERIC(8,2),
  Est_population_in_millions NUMERIC(11,6),
  Pct_unemployment NUMERIC(5,2),
  PRIMARY KEY (Country_name, Time_period),
  FOREIGN KEY (Country_name) REFERENCES Geographic_Location (Country_name));
  
  INSERT INTO Economic_Indicators (Country_name, Time_period, Est_gdp_in_billions, Est_population_in_millions, Pct_unemployment)
SELECT Country_name
	  ,Time_period
      ,Est_gdp_in_billions
      ,Est_population_in_millions
      ,Pct_unemployment    
FROM united_nations.Access_to_Basic_Services;


CREATE TABLE united_nations.Basic_Services (
  Country_name VARCHAR(37),
  Time_period INTEGER,
  Pct_managed_drinking_water_services NUMERIC(5,2),
  Pct_managed_sanitation_services NUMERIC(5,2),
  PRIMARY KEY (Country_name, Time_period),
  FOREIGN KEY (Country_name) REFERENCES Geographic_Location (Country_name)
);


    INSERT INTO Basic_Services (Country_name, Time_period, Pct_managed_drinking_water_services, Pct_managed_sanitation_services)
    SELECT Country_name
    	  ,Time_period
          ,Pct_managed_drinking_water_services
          ,Pct_managed_sanitation_services
    FROM united_nations.Access_to_Basic_Services;
    
    


    select * from Geographic_Location as a
left join Economic_Indicators as b
on a.country_name=b.country_name
left join basic_services as c
on a.country_name = c.country_name
and b.time_period = c.time_period
limit 5;

select a.region,a.country_name, b.time_period, ifnull(b.Pct_unemployment,19.59) as pct_unemployment_inputted
from geographic_location as a
left join economic_indicators as b
on a.country_name = b.country_name
where Region like '%Central and Southern Asia%'

union
select a.region,a.country_name, b.time_period, ifnull(b.Pct_unemployment,17.84) as pct_unemployment_inputted
from geographic_location as a
left join economic_indicators as b
on a.country_name = b.country_name
where Region like '%Northern Africa and Western Asia%'
;


select country_name, 
		round((Land_area/(select sum(Land_area) from geographic_location
				where sub_region = 'Middle Africa')*100)) as pct_regional_land from geographic_location
where sub_region = 'Middle Africa'
group by country_name;

select country_name, 
        round((Land_area/(select sum(Land_area) from geographic_location
                where sub_region = b.sub_region)*100)) as pct_regional_land from geographic_location as b
where sub_region = b.sub_region
group by country_name;


select avg(est_gdp_in_billions) from economic_indicators where time_period = 2020;


select a.country_name, a.time_period, a.est_gdp_in_billions, b.pct_managed_drinking_water_services
from economic_indicators a
inner join basic_services b
on a.country_name = b.country_name
and a.time_period = b.time_period

where a.time_period = 2020
and b.pct_managed_drinking_water_services <90
and a.est_gdp_in_billions > (select avg(est_gdp_in_billions) from economic_indicators where time_period = 2020);


WITH CTE AS
(SELECT LOWER(Country_name) country_name_lower FROM basic_services)

SELECT * FROM CTE WHERE country_name_lower = 'nigeria';

select lower(Country_name) country_name_lower FROM basic_services where lower(Country_name) = 'nigeria';

Select * from (
select Region,Country_name,Pct_managed_drinking_water_services,
Pct_managed_sanitation_services,Est_gdp_in_billions,
avg(Est_gdp_in_billions) over(partition by Region) as avg_gdp_per_region
from access_to_basic_services
where Region = 'Sub-Saharan Africa'
and time_period = 2020
and Pct_managed_drinking_water_services <60
) as regional_comparison
where Est_gdp_in_billions < avg_gdp_per_region;

with Regional_comparison as (Select * from (
select Region,Country_name,Pct_managed_drinking_water_services,
Pct_managed_sanitation_services,Est_gdp_in_billions,
avg(Est_gdp_in_billions) over(partition by Region) as avg_gdp_per_region
from access_to_basic_services
where Region = 'Sub-Saharan Africa'
and time_period = 2020
and Pct_managed_drinking_water_services <60
)as regions)

select * from regional_comparison
where Est_gdp_in_billions < avg_gdp_per_region;

create view country_unemployment_rate as
select a.country_name, b.time_period,ifnull(b.Pct_unemployment,33.65) as pct_unemployment_inputted
from geographic_location a
left join economic_indicators b
on a.country_name = b.country_name
where a.region = 'Sub-Saharan Africa';

