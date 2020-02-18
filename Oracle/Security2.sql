-- security ticket 23580

Select *
from ecomment.Enterprise ee
where customer_id=7864;

—notes -
Select Customer_Id as KareoId, ee.name as CompanyName, P.first_name, p.last_name, p.dob, n.Id NoteId, n.note_type_title , n.date_of_visit, N.status NoteStatus, ns.Display_Order, Ns.Data, nst.title NoteSectionType
from ecomment.enterprise EE
INNER JOIN HEALTHCARE.PATIENTS_vw P ON EE.ENTERPRISE_ID=P.ENTERPRISE_ID
JOIN HEALTHCARE.NOTES_vw N ON P.PATIENTS_ID=N.PATIENT_ID
LEFT JOIN HEALTHCARE.note_sections_vw NS ON ns.note_id = n.id
LEFT JOIN HEALTHCARE.note_section_types NST ON ns.note_section_type_id=nst.id
--Left Join Healthcare.patient_medications m on m.patient_id=p.patients_id
where ee.enterprise_id = 9521
order by n.date_of_visit, ns.display_order, nst.display_order
;

--labs
select *
from Labdata.lab_result r
Inner join Labdata.lab_order o on r.Lab_Order_id=o.Lab_order_id
Inner join labdata.lab_test_panel ltp on r.lab_result_id=ltp.lab_result_id
Inner join labdata.lab_test lt on ltp.lab_test_panel_id=lt.lab_test_panel_id
INNER JOIN HEALTHCARE.PATIENTS_vw P ON o.patients_id=p.patients_id
where ee.enterprise_id = 9521
;






—https://kareodev.atlassian.net/browse/NET-23580



select * from healthaudit.audit_user_login l,ecomment.enterprise e
where e.enterprise_id=l.practice_id and
e.customer_id=36569;

--------REPLACE CUSTOMERID with KID from Ticket

---Get the enterprise_id for that customer to find the right patient
Select *
from ecomment.Enterprise ee
where customer_id=36569;

-----Find the PATIENTGUID-  Replace patient first name and last name from the ticket
Select p.*
from HEALTHCARE.PATIENTS P
Inner join ecomment.enterprise ee on p.enterprise_id=ee.enterprise_id
inner join ehrdba.tempguid tg on tg.enterpriseid = ee.enterprise_id
;

--Notes -
Select Customer_Id as KareoId, ee.name as CompanyName, P.first_name, p.last_name, p.dob, n.Id NoteId, n.note_type_title , n.date_of_visit, N.status NoteStatus, ns.Display_Order, Ns.Data, nst.title NoteSectionType
from ecomment.enterprise EE
INNER JOIN HEALTHCARE.PATIENTS_vw P ON EE.ENTERPRISE_ID=P.ENTERPRISE_ID
JOIN HEALTHCARE.NOTES_vw N ON P.PATIENTS_ID=N.PATIENT_ID
LEFT JOIN HEALTHCARE.note_sections_vw NS ON ns.note_id = n.id
LEFT JOIN HEALTHCARE.note_section_types NST ON ns.note_section_type_id=nst.id
--Left Join Healthcare.patient_medications m on m.patient_id=p.patients_id
inner join ehrdba.tempguid tg on tg.enterpriseid = ee.enterprise_id
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
inner join ehrdba.tempguid tg on tg.enterpriseid = ee.enterprise_id
;


—Labs
Select *
from Labdata.lab_result r
Inner join Labdata.lab_order o on r.Lab_Order_id=o.Lab_order_id
Inner join labdata.lab_test_panel ltp on r.lab_result_id=ltp.lab_result_id
Inner join labdata.lab_test lt on ltp.lab_test_panel_id=lt.lab_test_panel_id
INNER JOIN HEALTHCARE.PATIENTS_vw P ON o.patients_id=p.patients_id
inner join ehrdba.tempguid tg on tg.enterpriseid = ee.enterprise_id
;

—Notes
Select *
from HEALTHCARE.PATIENTS_vw P
JOIN HEALTHCARE.NOTES_vw N ON P.PATIENTS_ID=N.PATIENT_ID
inner join ehrdba.tempguid tg on tg.enterpriseid = ee.enterprise_id;

select *
from healthcare.patients
where DOB=to_date('29/08/1939','dd/mm/yyyy') and enterprise_id=2537;
