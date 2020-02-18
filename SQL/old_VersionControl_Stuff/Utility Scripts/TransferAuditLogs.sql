
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @SourceCustomerID INT 
DECLARE @PracticeID INT
DECLARE @TargetCustomerID INT

SET @TargetCustomerID = xxx
SET @SourceCustomerID = xxx
SET @PracticeID = x


INSERT INTO dbo.AuditLog
        ( Application ,
          AuditActionTypeID ,
          AuditTypeID ,
          ChangeSet ,
          EntityTypeId ,
          EntityTypeText ,
          SubEntityTypeId ,
          SubEntityTypeText ,
          CustomerId ,
          PracticeId ,
          UserId ,
          UserName ,
          CreatedDate
        )
SELECT    AL.Application , -- Application - varchar(50)
          AL.AuditActionTypeID , -- AuditActionTypeID - int
          AL.AuditTypeID , -- AuditTypeID - int
          AL.ChangeSet , -- ChangeSet - xml
          AL.EntityTypeId , -- EntityTypeId - int
          AL.EntityTypeText , -- EntityTypeText - varchar(100)
          AL.SubEntityTypeId , -- SubEntityTypeId - int
          AL.SubEntityTypeText , -- SubEntityTypeText - varchar(100)
          @TargetCustomerID , -- CustomerId - int
          @PracticeID , -- PracticeId - int
          AL.UserId , -- UserId - int
          AL.UserName , -- UserName - varchar(50)
          AL.CreatedDate  -- CreatedDate - datetime
FROM dbo.AuditLog AL
WHERE CustomerId = @SourceCustomerID
	AND PracticeId = @PracticeID

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Audit logs transferred'

COMMIT 