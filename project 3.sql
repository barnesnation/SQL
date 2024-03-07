use md_water_services;

-- DROP TABLE IF EXISTS `auditor_report`;
-- CREATE TABLE `auditor_report` (
-- `location_id` VARCHAR(32),
-- `type_of_water_source` VARCHAR(64),
-- `true_water_source_score` int DEFAULT NULL,
-- `statements` VARCHAR(255)
-- );

select * from auditor_report;

SELECT a.location_id as audit_location,b.record_id, a.true_water_source_score as auditor_score, c.subjective_quality_score as employee_score
 FROM md_water_services.auditor_report a
 join visits b
 on a.location_id = b.location_id
 join water_quality c
 on b.record_id = c.record_id
 WHERE a.true_water_source_score = c.subjective_quality_score
 AND b.visit_count =1;
 
 
 SELECT a.location_id as audit_location,a.type_of_water_source as auditor_source ,d.type_of_water_source as survey_source ,b.record_id, a.true_water_source_score as auditor_score, c.subjective_quality_score as employee_score
 FROM md_water_services.auditor_report a
 join visits b
 on a.location_id = b.location_id
 join water_quality c
 on b.record_id = c.record_id
 join water_source d
 on b.source_id = d.source_id
 WHERE a.true_water_source_score <> c.subjective_quality_score
 AND b.visit_count =1;
 
 create view incorrect_records as (
 SELECT a.location_id as audit_location,b.record_id, d.employee_name, a.true_water_source_score as auditor_score, c.subjective_quality_score as employee_score, a.statements as statements
 FROM md_water_services.auditor_report a
 join visits b
 on a.location_id = b.location_id
 join water_quality c
 on b.record_id = c.record_id
 join employee d
 on b.assigned_employee_id = d.assigned_employee_id
 WHERE a.true_water_source_score <> c.subjective_quality_score
 AND b.visit_count =1);
 
with suspect_list as (
with error_count as ( 
select  employee_name, count(audit_location) as no_of_mistakes from incorrect_records
group by employee_name)

select employee_name, no_of_mistakes
from error_count
where no_of_mistakes > 6.0
)


select * from incorrect_records where employee_name in (select employee_name from suspect_list)
and audit_location in ('AkRu04508','AkRu07310','KiRu29639','AmAm09607');


with suspect_list as (
with error_count as ( 
select  employee_name, count(audit_location) as no_of_mistakes from incorrect_records
group by employee_name)

select employee_name, no_of_mistakes
from error_count
where no_of_mistakes > 6.0
)


select * from incorrect_records where employee_name not in (select employee_name from suspect_list)
and statements like '%cash%';


select * from visits