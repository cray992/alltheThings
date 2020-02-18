-- Oracle find patient demos

select
p.patients_ID,
p.enterprise_ID,
e.name as Practice,
p.First_Name,
p.last_name,
p.dob,
pa.address_line_1,
pa.address_line_2,
pa.city,
pa.state_id,
pa.postal_code,
e.customer_id
from healthcare.patients P
inner join ecomment.enterprise e on p.enterprise_ID = e.enterprise_id
inner join healthcare.patient_addresses pa on pa.patients_id = p.patients_id
where e.customer_id = 63524;
