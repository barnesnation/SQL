use united_nations;

show tables;

create table Country_List1(Country VARCHAR(200));

create table Geographic_Location (
Country_Name Varchar(37) Primary Key,
Sub_Region Varchar(25),
Region Varchar(32),
Land_Area numeric(10,2));

select * from Geographic_Location;

insert into Geographic_Location (Country_Name,Sub_Region,Region,Land_Area)
select Country_name,Sub_region,Region,avg(Land_area) as country_Area from access_to_basic_services
group by Country_name, Sub_region, Region;

create table Basic_Services (
Country_Name VARCHAR (37),
Time_Period integer,
Pct_managed_drinking_water_services numeric(5,2),
Pct_managed_sanitation_services numeric(5,2),
Primary key (Country_Name, Time_Period),
foreign key (Country_Name) references geographic_location (Country_Name));

insert into Basic_Services (Country_Name,Time_Period,Pct_managed_drinking_water_services,Pct_managed_sanitation_services)
select Country_name, Time_period, Pct_managed_drinking_water_services, Pct_managed_sanitation_services
from access_to_basic_services;

select * from basic_services;

create table Basic_Services (
Country_Name VARCHAR (37),
Time_Period integer,
Pct_managed_drinking_water_services numeric(5,2),
Pct_managed_sanitation_services numeric(5,2),
Primary key (Country_Name, Time_Period),
foreign key (Country_Name) references geographic_location (Country_Name));

