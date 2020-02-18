
—Security_Oracle

--Security Ticket 25898

select * from healthaudit.audit_user_login l,ecomment.enterprise e
where e.enterprise_id=l.practice_id and
e.customer_id=25898;

--------REPLACE CUSTOMERID with KID from Ticket

---Get the enterprise_id for that customer to find the right patient
Select *
from ecomment.Enterprise ee
where customer_id=25898;

-----Find the PATIENTGUID-  Replace patient first name and last name from the ticket
Select p.*
from HEALTHCARE.PATIENTS P
Inner join ecomment.enterprise ee on p.enterprise_id=ee.enterprise_id
where p.guid in (
'E7E79988786040459149CD1DCA65DDC5'
,'092C3A54056B90FFE053654C050AD495') and
--upper(first_name)=Upper('Arrington') and upper(last_name)=Upper('Greg')
ee.enterprise_id=30761;

--Notes -
Select Customer_Id as KareoId, ee.name as CompanyName, P.first_name, p.last_name, p.dob, n.Id NoteId, n.note_type_title , n.date_of_visit, N.status NoteStatus, ns.Display_Order, Ns.Data, nst.title NoteSectionType
from ecomment.enterprise EE
INNER JOIN HEALTHCARE.PATIENTS_vw P ON EE.ENTERPRISE_ID=P.ENTERPRISE_ID
JOIN HEALTHCARE.NOTES_vw N ON P.PATIENTS_ID=N.PATIENT_ID
LEFT JOIN HEALTHCARE.note_sections_vw NS ON ns.note_id = n.id
LEFT JOIN HEALTHCARE.note_section_types NST ON ns.note_section_type_id=nst.id
--Left Join Healthcare.patient_medications m on m.patient_id=p.patients_id
where
ee.enterprise_id=30761 AND
P.guid in
('E7E79988786040459149CD1DCA65DDC5'
,'32C0B6D3F79141BA94F69B3045C41C23’)
Order by n.date_of_visit, ns.display_order, nst.display_order;

Select *
from HEALTHCARE.NOTES_VW N
inner join HEALTHCARE.PATIENTS_vw  p ON P.PATIENTS_ID=N.PATIENT_ID

where enterprise_id=2537 and patients_id in (2219556,2218538);

--Medications -
Select Customer_Id as KareoId, ee.name as CompanyName, P.first_name, p.last_name, p.dob,m.Drug_name, M.strength, m.form, m.dosage_form, m.Raw_drug, m.closed_reason, m.intent, m.quantity, m.Ordered_at, m.closed_at,m.Prescriber_order_number
from ecomment.enterprise EE
INNER JOIN HEALTHCARE.PATIENTS_vw P ON EE.ENTERPRISE_ID=P.ENTERPRISE_ID
Join Healthcare.patient_medications m on m.patient_id=p.patients_id
where ee.enterprise_id=30761 AND P.guid in
('E7E79988786040459149CD1DCA65DDC5'
,'32C0B6D3F79141BA94F69B3045C41C23'
,'092C3A54056B90FFE053654C050AD495');



Select *
from Labdata.lab_result r
Inner join Labdata.lab_order o on r.Lab_Order_id=o.Lab_order_id
Inner join labdata.lab_test_panel ltp on r.lab_result_id=ltp.lab_result_id
Inner join labdata.lab_test lt on ltp.lab_test_panel_id=lt.lab_test_panel_id
INNER JOIN HEALTHCARE.PATIENTS_vw P ON o.patients_id=p.patients_id
where  P.guid='E45FC48FE9934B4C8A6D0BABE40A1C69';

Select *
from HEALTHCARE.PATIENTS_vw P
JOIN HEALTHCARE.NOTES_vw N ON P.PATIENTS_ID=N.PATIENT_ID
where p.guid='552D55D642D344AF848145DA898517A3';

select *
from healthcare.patients
where DOB=to_date('29/08/1939','dd/mm/yyyy') and enterprise_id=2537;
