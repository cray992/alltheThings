
/*-----------------------------------------------------------------------------
Case 8635:   Add new document status codes to GR training and main databases
-------------------------------------------------------------------------------

Insert the following Document Status Type values for GR Med:

Back from Client
Back from Coding
Back from Insurance Verification
Coding
Completed Charges
Completed Payments
Correspondence
Correspondence – Completed
Data Processing Charges
Data Processing Charges – Dept. 2
Data Processing Payments
Data Processing Payments – Dept. 2
Error (existing)
Insurance Verification
Mail Room
New (existing)
Processed (existing)
Return to Client
Return to GRMM from Dept. 2

-----------------------------------------------------------------------------*/

INSERT INTO [DocumentStatusType]
           ([DocumentStatusTypeID]
           ,[Name]
           ,[Description]
           ,[SortOrder])
VALUES     (4
           ,'Back from Client'
           ,'Back from Client'
           ,1)

INSERT INTO [DocumentStatusType]
           ([DocumentStatusTypeID]
           ,[Name]
           ,[Description]
           ,[SortOrder])
VALUES     (5
           ,'Back from Coding'
           ,'Back from Coding'
           ,2)

INSERT INTO [DocumentStatusType]
           ([DocumentStatusTypeID]
           ,[Name]
           ,[Description]
           ,[SortOrder])
VALUES     (6
           ,'Back from Insurance Verification'
           ,'Back from Insurance Verification'
           ,3)

INSERT INTO [DocumentStatusType]
           ([DocumentStatusTypeID]
           ,[Name]
           ,[Description]
           ,[SortOrder])
VALUES     (7
           ,'Coding'
           ,'Coding'
           ,4)

INSERT INTO [DocumentStatusType]
           ([DocumentStatusTypeID]
           ,[Name]
           ,[Description]
           ,[SortOrder])
VALUES     (8
           ,'Completed Charges'
           ,'Completed Charges'
           ,5)

INSERT INTO [DocumentStatusType]
           ([DocumentStatusTypeID]
           ,[Name]
           ,[Description]
           ,[SortOrder])
VALUES     (9
           ,'Completed Payments'
           ,'Completed Payments'
           ,6)

INSERT INTO [DocumentStatusType]
           ([DocumentStatusTypeID]
           ,[Name]
           ,[Description]
           ,[SortOrder])
VALUES     (10
           ,'Correspondence'
           ,'Correspondence'
           ,7)

INSERT INTO [DocumentStatusType]
           ([DocumentStatusTypeID]
           ,[Name]
           ,[Description]
           ,[SortOrder])
VALUES     (11
           ,'Correspondence – Completed'
           ,'Correspondence – Completed'
           ,8)

INSERT INTO [DocumentStatusType]
           ([DocumentStatusTypeID]
           ,[Name]
           ,[Description]
           ,[SortOrder])
VALUES     (12
           ,'Data Processing Charges'
           ,'Data Processing Charges'
           ,9)

INSERT INTO [DocumentStatusType]
           ([DocumentStatusTypeID]
           ,[Name]
           ,[Description]
           ,[SortOrder])
VALUES     (13
           ,'Data Processing Charges – Dept. 2'
           ,'Data Processing Charges – Dept. 2'
           ,10)

INSERT INTO [DocumentStatusType]
           ([DocumentStatusTypeID]
           ,[Name]
           ,[Description]
           ,[SortOrder])
VALUES     (14
           ,'Data Processing Payments'
           ,'Data Processing Payments'
           ,11)

INSERT INTO [DocumentStatusType]
           ([DocumentStatusTypeID]
           ,[Name]
           ,[Description]
           ,[SortOrder])
VALUES     (15
           ,'Data Processing Payments – Dept. 2'
           ,'Data Processing Payments – Dept. 2'
           ,12)

UPDATE [DocumentStatusType]
SET        [SortOrder] = 13
WHERE      [Name] = 'Error'

INSERT INTO [DocumentStatusType]
           ([DocumentStatusTypeID]
           ,[Name]
           ,[Description]
           ,[SortOrder])
VALUES     (16
           ,'Insurance Verification'
           ,'Insurance Verification'
           ,14)

INSERT INTO [DocumentStatusType]
           ([DocumentStatusTypeID]
           ,[Name]
           ,[Description]
           ,[SortOrder])
VALUES     (17
           ,'Mail Room'
           ,'Mail Room'
           ,15)

UPDATE [DocumentStatusType]
SET        [SortOrder] = 16
WHERE      [Name] = 'New'

UPDATE [DocumentStatusType]
SET        [SortOrder] = 17
WHERE      [Name] = 'Processed'

INSERT INTO [DocumentStatusType]
           ([DocumentStatusTypeID]
           ,[Name]
           ,[Description]
           ,[SortOrder])
VALUES     (18
           ,'Return to Client'
           ,'Return to Client'
           ,18)

INSERT INTO [DocumentStatusType]
           ([DocumentStatusTypeID]
           ,[Name]
           ,[Description]
           ,[SortOrder])
VALUES     (19
           ,'Return to GRMM from Dept. 2'
           ,'Return to GRMM from Dept. 2'
           ,19)


GO