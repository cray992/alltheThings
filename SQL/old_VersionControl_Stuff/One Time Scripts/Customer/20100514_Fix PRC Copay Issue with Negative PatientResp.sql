-- If the encounter procedure has a negative PatientResp AND
-- the claim transaction history does not contain a positive PRC for that amount at approval AND
-- there is a payment created with the encounter (Notes contains Payment made with encounter) AND
-- the first transfer is not to patient
-- THEN
-- Update the PatientResp for the EncounterProcedure manually to 0
-- Call the ClaimDataProvider_PRCopayTransfer making sure the update encounter procedure bit is true
-- 
-- ?? If ultimately assigned to patient everything is ok?
-- ?? 

declare @SaveHistory bit
declare @Process bit
declare @ModifyPatientResp bit
set @SaveHistory = 1
set @Process = 1
set @ModifyPatientResp = 1

-- Collect Claims that have a negative PatientResp with a Payment
declare @ClaimsPossiblyAffected table(	ID int identity(1,1),
										PracticeID int, 
										ClaimID int, 
										PostingDate datetime, 
										PatientResp money, 
										OriginalCharge money,
										ContainsPRCAlready bit, 
										FirstTransferPatient bit,
										Settled bit,
										ModifiedPatientResp bit, 
										ModifiedPatientRespToPostivie bit, 
										AddedPRC bit)

insert into @ClaimsPossiblyAffected (PracticeID, ClaimID, PostingDate, PatientResp, OriginalCharge, ContainsPRCAlready, FirstTransferPatient, Settled, ModifiedPatientResp, ModifiedPatientRespToPostivie, AddedPRC)
select	c.PracticeID,		-- PracticeID
		c.ClaimID,			-- ClaimID
		e.PostingDate,		-- PostingDate
		ep.PatientResp*-1,	-- PatientResp
		0.0,				-- OriginalCharge
		0,					-- ContainsPRCAlready
		0,					-- FirstTransferPatient
		0,					-- Settled
		0,					-- ModifiedPatientResp
		0,					-- ModifiedPatientRespToPostivie
		0					-- AddedPRC
from encounterprocedure ep
inner join claim c
on c.encounterprocedureid=ep.encounterprocedureid
inner join encounter e
on e.encounterid=ep.encounterid
inner join payment p
on p.sourceencounterid=e.encounterid
where patientresp < 0

-- Update the ContainsPRCAlready for any claims that already have the correct PRC
-- (any PRC posted on the encounter's posting date will be assumed to be ok)
update c
set ContainsPRCAlready=1
from @ClaimsPossiblyAffected c
inner join ClaimTransaction ct
on ct.ClaimID=c.ClaimID
where ct.ClaimTransactionTypeCode='PRC'
and CONVERT(varchar(10), ct.PostingDate, 101)=CONVERT(varchar(10), c.PostingDate, 101)

-- Update the FirstTransferPatient bit for claims that were originally assigned to patient
update c
set FirstTransferPatient=case when ct.ReferenceID is null then 1 else 0 end
from @ClaimsPossiblyAffected c
inner join claimtransaction ct
on ct.claimid=c.claimid
inner join (select c.claimid, min(ClaimTransactionID) as claimtransactionid
			from claimtransaction ct
			inner join @ClaimsPossiblyAffected c
			on c.claimid=ct.claimid
			where ct.claimtransactiontypecode='ASN'
			group by c.claimid) cta
on cta.claimtransactionid=ct.claimtransactionid

-- Update the Settled bit for claims that were finally settled
update c
set Settled=case when ct.ReferenceID is null then 1 else 0 end
from @ClaimsPossiblyAffected c
inner join claimtransaction ct
on ct.claimid=c.claimid
inner join (select c.claimid, max(ClaimTransactionID) as claimtransactionid
			from claimtransaction ct
			inner join @ClaimsPossiblyAffected c
			on c.claimid=ct.claimid
			where ct.claimtransactiontypecode='END'
			group by c.claimid) cta
on cta.claimtransactionid=ct.claimtransactionid

-- Update the OriginalCharge amount for claims
update c
set OriginalCharge=ct.Amount 
from @ClaimsPossiblyAffected c
inner join claimtransaction ct
on ct.claimid=c.claimid
inner join (select c.claimid, min(ClaimTransactionID) as claimtransactionid
			from claimtransaction ct
			inner join @ClaimsPossiblyAffected c
			on c.claimid=ct.claimid
			where ct.claimtransactiontypecode='CST'
			group by c.claimid) cta
on cta.claimtransactionid=ct.claimtransactionid

-- Save the data if requested
if @SaveHistory = 1
begin
	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_ClaimsAffectedPatientResp]') AND type in (N'U'))
		drop table Temp_ClaimsAffectedPatientResp
	
	select *
	into Temp_ClaimsAffectedPatientResp
	from @ClaimsPossiblyAffected
end
else
begin
	select *
	from @ClaimsPossiblyAffected
end

if @Process = 1
begin
	declare @MaxID int
	declare @CurrentID int

	declare @ClaimID int
	declare @PostingDate datetime
	declare @PatientResp money
	declare @OriginalCharge money
	declare @ModifiedPatientResp bit
	declare @FirstTransferPatient bit

	select	@MaxID = max(ID),
			@CurrentID = min(ID)
	from @ClaimsPossiblyAffected 
	where ContainsPRCAlready=0 
	
	while @CurrentID <= @MaxID
	begin
		SET @ModifiedPatientResp = 0
	
		select	@ClaimID = ClaimID,
				@PostingDate = PostingDate,
				@PatientResp = PatientResp,
				@OriginalCharge = OriginalCharge,
				@FirstTransferPatient = FirstTransferPatient
		from @ClaimsPossiblyAffected
		where ID = @CurrentID
		
		-- Update the PatientResp, set to Original Charge if it is greater
		IF @ModifyPatientResp = 1 AND @PatientResp > @OriginalCharge AND @OriginalCharge > 50
		BEGIN
			SET @PatientResp = @OriginalCharge
			SET @ModifiedPatientResp = 1
		END
		
		print 'ClaimID=' + cast(@ClaimID as varchar(10)) + ', ID=' + cast(@CurrentID as varchar(10))

		UPDATE EP
		SET EP.PatientResp=0 
		FROM EncounterProcedure EP
		INNER JOIN Claim C ON C.EncounterProcedureID = EP.EncounterProcedureID
		WHERE C.ClaimID = @ClaimID

		-- We only want to add a PRC if the first transfer patient does not exist
		IF @FirstTransferPatient = 0
		BEGIN
			EXEC ClaimDataProvider_PRCopayTransfer @ClaimID, NULL, @PostingDate,
												   @PatientResp, NULL, 1, 1
		END
		
		update	Temp_ClaimsAffectedPatientResp
		set		AddedPRC=CASE WHEN @FirstTransferPatient=1 THEN 0 ELSE 1 END,
				ModifiedPatientRespToPostivie=1, 
				ModifiedPatientResp=@ModifiedPatientResp
		where	ID = @CurrentID

		select @CurrentID = min(ID)
		from @ClaimsPossiblyAffected
		where ID > @CurrentID
		AND ContainsPRCAlready=0 
	end
end
-- Hippocratic Solutions/Center for Preventative Medicine
-- 2411, claim 9060 has messed up claim transaction history after applying (bug in claim transaction patresp?)
select	p.name as PracticeName, c.*
from Temp_ClaimsAffectedPatientResp c
inner join practice p
on p.practiceid=c.practiceid
--where ModifiedPatientRespToPostivie=1 and addedprc=0
order by c.id, c.practiceid, ClaimID
--where claimid in (126108, 144547)
--AND ContainsPRCAlready=0 
--AND FirstTransferPatient=0


/*
select	p.Name, pa.PatientID, pa.FirstName, pa.LastName, c.*
from Temp_ClaimsAffectedPatientResp c
inner join practice p
on p.practiceid=c.practiceid
inner join claim cl
on c.claimid=cl.claimid
inner join patient pa
on cl.patientid=pa.patientid
order by c.practiceid, ClaimID

select * from claimtransaction where claimid=208
select * from claimtransaction where claimid=207

select * from claim where claimid=208
select * from encounterprocedure where encounterprocedureid=489
select * from encounterprocedure where encounterid=439
update encounterprocedure set patientresp=0 where encounterid=439

select ep.* from encounterprocedure ep
inner join encounter e
on e.encounterid=ep.encounterid
where ep.patientresp < 0 
and ep.createddate > '12/1/2009' 
and e.practiceid=5
order by ep.encounterid

select * from encounter where encounterid=136412
select * from practice

select EP.*
FROM EncounterProcedure EP
INNER JOIN Claim C ON C.EncounterProcedureID = EP.EncounterProcedureID
WHERE C.ClaimID=14296


select * from claimtransaction where claimid=152463 
select * from claimaccounting where claimid=152463 

select count(*) from encounterprocedure where patientresp<0

-- Fix for claim 153908
UPDATE EP
SET EP.PatientResp=0 
FROM EncounterProcedure EP
INNER JOIN Claim C ON C.EncounterProcedureID = EP.EncounterProcedureID
WHERE C.ClaimID=153908

EXEC ClaimDataProvider_PRCopayTransfer 153908, NULL, '1/28/2010',
									   25, NULL, 1, 1

-- Fix for claim 178620
UPDATE EP
SET EP.PatientResp=0 
FROM EncounterProcedure EP
INNER JOIN Claim C ON C.EncounterProcedureID = EP.EncounterProcedureID
WHERE C.ClaimID=152517

EXEC ClaimDataProvider_PRCopayTransfer 152517, NULL, '1/23/2010',
									   25, NULL, 1, 1
*/
