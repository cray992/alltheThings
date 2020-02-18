SET nocount on;

declare
@RunDate DATETIME = cast(sysdatetime() as DATE),
@MonthsDifference INT = 6,
@CurrentMonthPassed INT = day(cast(sysdatetime() as DATE)),
@ReturnedRows VARCHAR(16),
@MSG VARCHAR(512);

declare
@StartDate DATETIME = dateadd(month,-@MonthsDifference,@RunDate),
@EndDate DATETIME = @RunDate;

/* Customer list and products */
if object_id('tempdb..#CustomerList','U') is not null
drop table #CustomerList;
--ALTER TABLE #customerlist ADD partnername varchar(30)
--if not exists (select top 1 1 from sys.indexes where name = 'IX_tmp_Deactivation_Inc_Customer_Practice_Provider_Product'
-- and object_name(object_id) = 'ProductDomain_ProductSubscription')
-- create NONCLUSTERED INDEX IX_tmp_Deactivation_Inc_Customer_Practice_Provider_Product
-- on dbo.ProductDomain_ProductSubscription (DeactivationDate)
-- include (CustomerId,PracticeGuid,ProviderGuid,ProductId,ActivationDate);

select
identity(INT,1,1) as RowNum,
PS.CustomerId,
cast(
replace(
quotename(
replace(
ltrim(rtrim(
replace(
replace(
replace(
C.CompanyName /* Text column to be cleansed. */
,char(9),' ') /* Replace and tab with a space. */
,char(10),' ') /* Replace any line feed with a space. */
,char(13),' ') /* Replace any carriage return with a space. */
)) /* Trim leading or trailing whitespace after special chars replace. */
,' ',' ') /* Replace double spaces to one space (especially between words). */
,'"') /* Encapsulate text with " to protect apostrophes. */
,'"','') /* Remove the encasuplating " after all other cleaning steps. */
as VARCHAR(128)) as CompanyName, /* Cast exact data type and column name as needed. */
PS.PracticeGuid,
PS.ProviderGuid,
PS.ProductId,
C.[State] as HQ_State,
case when P.ProductName = 'PM' then 1 end as ActivePM,
case when P.ProductName = 'KareoEhr' then 1 end as ActiveClinical,
case when P.ProductName = 'KareoOffice' then 1 end as ActiveMarketing,
case when P.ProductName = 'PM' and CT.CompanyTypeCaption = 'Billing Services Provider' then 1 end as ActiveBillCoEdition,
case when P.ProductName = 'RCM' then 1 end as ActiveKMB,
case when CT.CompanyTypeCaption = 'Billing Services Provider' then 1 end as BillCoAccount,
min(PS.ActivationDate) as FirstActivated,
pt.Name
into #CustomerList
from SHAREDSERVER.superbill_shared.dbo.ProductDomain_ProductSubscription as PS (nolock)
join SHAREDSERVER.superbill_shared.dbo.Customer C (nolock)
on PS.CustomerId = C.CustomerID
and C.Cancelled = 0
and C.DBActive = 1
and C.CustomerType = 'N'
join SHAREDSERVER.superbill_shared.dbo.ProductDomain_Product P (nolock)
on PS.ProductId = P.ProductId
and P.ProductName <> 'Platform'
join SHAREDSERVER.superbill_shared.dbo.[Partner] PT (nolock)
on C.PartnerID = PT.PartnerID
and PT.Name <> 'Quest'
left join SHAREDSERVER.superbill_shared.dbo.CompanyType CT (nolock)
on C.CompanyTypeID = CT.CompanyTypeID
where (PS.DeactivationDate is null or Ps.DeactivationDate >= @RunDate)
group by
PS.CustomerId,
C.CompanyName,
P.ProductName,
CT.CompanyTypeCaption,
PS.PracticeGuid,
PS.ProviderGuid,
PS.ProductId,
C.[State],
pt.name;

set @ReturnedRows = cast(@@ROWCOUNT as VARCHAR);

create clustered index IXC_tmp_CustomerList
on #CustomerList (CustomerID, ProductID, PracticeGUID, ProviderGUID);

set @MSG = 'CustomerList and Products: ' + @ReturnedRows;
raiserror(@MSG,0,1) with nowait;

/* Flattened Customer Fields from Products */
if object_id('tempdb..#CustomerFlags','U') is not null
drop table #CustomerFlags;

;with CustomerCounts as (
select
C.CustomerId ,
C.CompanyName ,
C.HQ_State,
count(distinct C.PracticeGuid) as Practices ,
count(distinct C.ProviderGuid) as Providers ,
sum(C.ActivePM) as ActivePM,
sum(C.ActiveClinical) as ActiveClinical,
sum(C.ActiveMarketing) as ActiveMarketing ,
sum(C.ActiveBillCoEdition) as ActiveBillCoEdition ,
sum(C.ActiveKMB) as ActiveKMB,
sum(C.BillCoAccount) as BillCoAccount,
min(C.FirstActivated) as InitialAccountActivationDate
from #CustomerList C
group by
C.CustomerId ,
C.CompanyName,
C.HQ_State
)

select
CustomerId ,
CompanyName ,
HQ_State,
Practices ,
Providers ,
case when ActivePM > 0 then 'Yes' else 'No' end as ActivePM ,
case when ActiveClinical > 0 then 'Yes' else 'No' end as ActiveClinical ,
case when ActiveMarketing > 0 then 'Yes' else 'No' end as ActiveMarketing ,
case when ActiveBillCoEdition > 0 then 'Yes' else 'No' end as ActiveBillCoEdition ,
case when ActiveKMB > 0 then 'Yes' else 'No' end as ActiveKMB ,
case when BillCoAccount > 0 then 'Yes' else 'No' end as BillCoAccount ,
InitialAccountActivationDate
into #CustomerFlags
from CustomerCounts;
set @ReturnedRows = cast(@@ROWCOUNT as VARCHAR);

create clustered index IXC_tmp_CUstomerFlags
on #CustomerFlags (CustomerID);

set @MSG = 'Customer Flags: ' + @ReturnedRows;
raiserror(@MSG,0,1) with nowait;

/* Distinct CustomerIDs with Product ID (needed for MRR) */
if object_id('tempdb..#CustomerProducts','U') is not null
drop table #CustomerProducts;

select distinct
CustomerID,
ProductID,
name
into #CustomerProducts
FROM #CustomerList;
set @ReturnedRows = cast(@@ROWCOUNT as VARCHAR);

create clustered index IXC_tmp_CUstomerProducts
on #CustomerProducts (CustomerID,ProductID);

set @MSG = 'Customer Products: ' + @ReturnedRows;
raiserror(@MSG,0,1) with nowait;

/* Monthly Recurring revenue */
if object_id('tempdb..#InvoiceRuns','U') is not null
drop table #InvoiceRuns;

select R.InvoiceRunID
into #InvoiceRuns
from SHAREDSERVER.superbill_shared.dbo.BillingInvoicing_InvoiceRun as R (nolock)
where R.InvoiceDate between @StartDate and @RunDate;
set @ReturnedRows = cast(@@ROWCOUNT as VARCHAR);

create clustered index IX_tmp_InvoiceRuns
on #InvoiceRuns (InvoiceRunID);

set @MSG = 'InvoiceRuns collected: ' + @ReturnedRows;
raiserror(@MSG,0,1) with nowait;

if object_id('tempdb..#MRRs','U') is not null
drop table #MRRs;

select
D.CustomerId,
--D.ProductId,
case
when sum(E.Price * E.Qty) <> 0 then cast(isnull(sum(E.Price * E.Qty),0.0) / @MonthsDifference as MONEY)
else cast(isnull(sum(I.Price * I.Qty),0.0) / @MonthsDifference as MONEY)
end as MRR
into #MRRs
from #CustomerProducts as D
join SHAREDSERVER.superbill_shared.dbo.BillingInvoicing_InvoiceDetail as I (nolock)
on D.CustomerId = I.CustomerID
and I.Deleted = 0
and I.Posted = 1
join #InvoiceRuns IR
on I.InvoiceRunID = IR.InvoiceRunID
join SHAREDSERVER.superbill_shared.dbo.KareoProductLineItem as K (nolock)
on I.KareoProductLineItemID = K.KareoProductLineItemID
and D.ProductId = K.Subscription_ProductDomain_ProductId
left join SHAREDSERVER.superbill_shared.dbo.BillingInvoicing_InvoiceEdits as E (nolock)
on I.InvoiceDetailID = E.InvoiceDetailID
group by
D.CustomerId;
--D.ProductId;
set @ReturnedRows = cast(@@ROWCOUNT as VARCHAR);

create clustered index IXC_tmp_MRRs
on #MRRs (CustomerId,MRR);

set @MSG = 'Monthly Recurring Revenue: ' + @ReturnedRows;
raiserror(@MSG,0,1) with nowait;

/* Salesforce Account Managers */
if object_id('tempdb..#AcctMgrs','U') is not null
drop table #AcctMgrs;

select
cast(SA.KAREOCUSTOMERID__C as INT) as CustomerID,
--SA.ACCOUNT_MANAGER__C,
cast(U.FIRSTNAME + ' ' + U.LASTNAME as VARCHAR(256)) as AccountManager
into #AcctMgrs
from #CustomerFlags C
join [DAW-DW01].SFDC_Sesame.dbo.SF_ACCOUNT SA with (nolock)
on C.CustomerId = cast(SA.KAREOCUSTOMERID__C as INT)
and SA.ACCOUNT_MANAGER__C is not null
join [DAW-DW01].SFDC_Sesame.dbo.SF_User U with (nolock)
on SA.ACCOUNT_MANAGER__C = U.ID;
set @ReturnedRows = cast(@@ROWCOUNT as VARCHAR);

create clustered index IXC_tmp_AcctMgrs
on #AcctMgrs (CustomerId,AccountManager);

set @MSG = 'SF Account Managers: ' + @ReturnedRows;
raiserror(@MSG,0,1) with nowait;

SELECT DISTINCT 
C.CustomerId as KID,
C.CompanyName as AccountName,
C.HQ_State,
C.Practices,
C.Providers,
C.ActivePM,
C.ActiveClinical,
C.ActiveMarketing,
C.ActiveKMB,
C.ActiveBillCoEdition,
C.BillCoAccount,
C.InitialAccountActivationDate,
cl.Name AS partnername,
M.MRR as [6MonthRR],
AM.AccountManager
--SELECT * 
from #CustomerFlags C
left join #MRRs as M
on C.CustomerId = M.CustomerId
left join #AcctMgrs AM
on C.CustomerId = AM.CustomerID
left JOIN #CustomerList cl 
ON cl.CustomerId = C.CustomerId


--if exists (select top 1 1 from SHAREDSERVER.superbill_shared.sys.indexes where name = 'IX_tmp_Deactivation_Inc_Customer_Practice_Provider_Product'
-- and object_name(object_id) = 'ProductDomain_ProductSubscription')
-- --drop index IX_tmp_Deactivation_Inc_Customer_Practice_Provider_Product on SHAREDSERVER.superbill_shared.dbo.ProductDomain_ProductSubscription;
