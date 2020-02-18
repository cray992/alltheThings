----Tx HPI Tax Audit

USE superbill_shared
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED



select cl.*
into tx_tax_audit_encounters
from DataCollection.dbo.[KMBCustList$] cl WITH (NOLOCK)
	JOIN [KareoDBA].[dbo].[getEncounter] en ON en.customerid = cl.CustomerID
	;

SELECT ul.customerid AS CustomerID, YEAR(eventdate) AS 'Year', MONTH(eventdate)AS 'Month'
	, ul.loginuseremailaddress AS UserEmail, ad.DoctorGuid, COUNT( loginuseremailaddress) AS 'LoginCount'
INTO  Tx_Tax_Audit
FROM DataCollection.dbo.hpi_userlogins ul WITH (NOLOCK)
	JOIN dbo.Customer c WITH (NOLOCK)ON c.CustomerID = ul.customerid
	JOIN DataCollection.dbo.[KMBCustList$] cl WITH (NOLOCK)ON cl.CustomerID = ul.customerid
	JOIN dbo.CustomerUsers cu WITH (NOLOCK)ON cu.CustomerID = cl.CustomerID
	JOIN dbo.Users u WITH (NOLOCK)ON u.UserID = cu.UserID --AND u.CreatedDate BETWEEN '2019-01-01 01:01:00 ' AND GETDATE()
	JOIN DataCollection.dbo.AllDocs ad with (NOLOCK)ON ad.CustomerID = cu.CustomerID AND ad.UserID = cu.UserID
	--JOIN [KareoDBA].[dbo].[getEncounter] en ON en.customerid = cl.CustomerID
	JOIN dbo.tx_tax_audit_encounters en with (NOLOCK) ON en.customerid = cl.CustomerID
WHERE (eventdate BETWEEN '2019-01-01 01:01:00 ' AND GETDATE()) AND ul.loginuseremailaddress NOT LIKE '%kareo%' AND c.State = 'tx' --AND u.EmailAddress NOT LIKE '%kareo%'
GROUP BY  YEAR(eventdate), MONTH(eventdate), ul.customerid, ul.loginuseremailaddress, ad.DoctorGuid --, u.EmailAddress
--ORDER BY ul.customerid, Year, MONTH

select * from Tx_Tax_Audit where
UserEmail not like '%patientlyspeaking.com' and
UserEmail not like '%hpiinc.com'
ORDER BY customerid, Year, MONTH
