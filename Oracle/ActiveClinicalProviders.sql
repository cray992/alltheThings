—Provide active clinical providers from Oracle

—Oracle
Select distinct r.PRESCRIBER_ID as ProviderID, p.guid as ProviderGuid, u.guid as UserGuid, e.guid as EnterpriseGuid
from HEALTHCARE.RX_REQUESTS r
inner join ECOMMENT.ENTERPRISE_USERS_VW vw on r.prescriber_id=vw.enterprise_site_user_id
Inner join ecomment.enterprise_site_user esu on vw.ENTERPRISE_SITE_USER_ID=esu.ENTERPRISE_SITE_USER_ID
Inner join reg.users u on esu.USERID=u.USERID
--LEFT JOIN HEALTHCARE.NOTES_vw N ON u.USERID=N.USER_ID
Left Join ecomment.Provider P on u.USERID=P.USERID
Left join ecomment.enterprise e on p.enterprise_id=e.enterprise_id
where to_date('2019-01-01', 'YYYY-MM-DD') <= r.CREATED_AT AND r.CREATED_AT < sysdate; --to_date('2019-01-01', 'YYYY-MM-DD');

Select distinct vw.ENTERPRISE_SITE_USER_ID as ProviderID, p.guid as ProviderGuid, u.guid as UserGuid, e.guid as EnterpriseGuid
from
ECOMMENT.ENTERPRISE_USERS_VW vw
JOIN ecomment.enterprise_site_user esu on vw.ENTERPRISE_SITE_USER_ID=esu.ENTERPRISE_SITE_USER_ID
JOIN reg.users u on esu.USERID=u.USERID
JOIN HEALTHCARE.NOTES_vw N ON u.USERID=N.USER_ID
Left Join ecomment.Provider P on u.USERID=P.USERID
Left join ecomment.enterprise e on p.enterprise_id=e.enterprise_id
where p.guid is not null and to_date('2019-01-01', 'YYYY-MM-DD') <= n.CREATED_AT AND n.CREATED_AT < sysdate; --to_date('2019-01-01', 'YYYY-MM-DD');
;

—SQL
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
INSERT INTO sharedserver.datacollection.dbo.ProvidersALL
SELECT dbo.fn_GetCustomerID(),d.practiceid,P.PracticeGuid, D.DoctorGuid, Pt.ProviderTypeName, d.ActiveDoctor, PT.ProviderTypeId
FROM Doctor D
Inner join ProviderType PT on D.providerTypeID=PT.ProviderTypeID
Inner join Practice P on d.practiceid=p.practiceId
Left Join sharedserver.datacollection.dbo.ProvidersAll pa on pa.Doctorguid=D.doctorguid and pa.practiceguid=p.practiceguid
where [external]=0 and pa.doctorguid is NULL;
