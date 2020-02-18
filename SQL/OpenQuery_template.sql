—Open Query

SELECT PaymentID, PracticeID, PaymentAmount, PaymentMethodCode, PayerTypeCode, PayerID, PaymentNumber, Description, CreatedDate, ModifiedDate, TIMESTAMP, SourceEncounterID, PostingDate, PaymentTypeID, DefaultAdjustmentCode, BatchID, CreatedUserID,
ModifiedUserID, SourceAppointmentID, CONVERT(XML,EOBEditable)AS EOBEditable, AdjudicationDate, ClearinghouseResponseID, CONVERT(XML,ERAErrors)AS ERAErrors, AppointmentID, AppointmentStartDate, PaymentCategoryID, overrideClosingDate, IsOnline
INTO Payment_23489
FROM OPENQUERY ( [LAS-PDW-D045] ,'SELECT PaymentID, PracticeID, PaymentAmount, PaymentMethodCode, PayerTypeCode, PayerID, PaymentNumber, Description, CreatedDate, ModifiedDate, TIMESTAMP, SourceEncounterID, PostingDate, PaymentTypeID, DefaultAdjustmentCode, BatchID, CreatedUserID,
ModifiedUserID, SourceAppointmentID, CONVERT(nvarchar (MAX),EOBEditable)AS EOBEditable, AdjudicationDate, ClearinghouseResponseID, CONVERT(nvarchar (MAX),ERAErrors)as ERAErrors, AppointmentID, AppointmentStartDate, PaymentCategoryID, overrideClosingDate, IsOnline
FROM superbill_23489_prod.dbo.Payment WITH (NOLOCK)
WHERE createddate>GETDATE()-365' )  
