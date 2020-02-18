DELETE R FROM dbo.Report AS R
LEFT JOIN dbo.ReportCategory AS RC ON R.ReportCategoryID = RC.ReportCategoryID
where IsVisible = 0

DELETE dbo.ReportCategory
WHERE IsVisible = 0




DECLARE @ReportCategoryID INT

INSERT INTO dbo.ReportCategory
        ( DisplayOrder ,
          Image ,
          Name ,
          Description ,
          TaskName ,
          ModifiedDate ,
          MenuName ,
          PracticeSpecific,
          IsVisible
        )
VALUES  ( -1 , -- DisplayOrder - int
          '' , -- Image - varchar(128)
          'Hidden' , -- Name - varchar(128)
          'Hidden Reports used for printing' , -- Description - varchar(256)
          '' , -- TaskName - varchar(128)
          GETDATE(), -- ModifiedDate - datetime
          '' , -- MenuName - varchar(128)
          1,  -- PracticeSpecific - bit
          0 --IsVisible - bit
        )
        
SET @ReportCategoryID = @@IDENTITY
        
INSERT INTO dbo.Report
        ( ReportCategoryID ,
          DisplayOrder ,
          Image ,
          Name ,
          Description ,
          TaskName ,
          ReportPath ,
          ReportParameters ,
          ModifiedDate ,
          MenuName ,
          PermissionValue ,
          PracticeSpecific
        )
SELECT  @ReportCategoryID , -- ReportCategoryID - int
          -1 , -- DisplayOrder - int
          '' , -- Image - varchar(128)
          'rptPaymentAuthorizationReceipt' , -- Name - varchar(128)
          'rptPaymentAuthorizationReceipt used for printing' , -- Description - varchar(256)
          '/BusinessManagerReports/rptPaymentAuthorizationReceipt' , -- TaskName - varchar(128)
          '' , -- ReportPath - varchar(256)
          NULL , -- ReportParameters - xml
          GETDATE() , -- ModifiedDate - datetime
          '' , -- MenuName - varchar(128)
          '' , -- PermissionValue - varchar(128)
          1  -- PracticeSpecific - bit
UNION ALL
SELECT  @ReportCategoryID , -- ReportCategoryID - int
          -1 , -- DisplayOrder - int
          '' , -- Image - varchar(128)
          'rptGetActivities_TransactionSummary' , -- Name - varchar(128)
          'rptGetActivities_TransactionSummary used for printing' , -- Description - varchar(256)
          '' , -- TaskName - varchar(128)
          '/BusinessManagerReports/rptGetActivities_TransactionSummary' , -- ReportPath - varchar(256)
          NULL , -- ReportParameters - xml
          GETDATE() , -- ModifiedDate - datetime
          '' , -- MenuName - varchar(128)
          '' , -- PermissionValue - varchar(128)
          1  -- PracticeSpecific - bit
UNION ALL
SELECT  @ReportCategoryID , -- ReportCategoryID - int
          -1 , -- DisplayOrder - int
          '' , -- Image - varchar(128)
          'rptGetActivities_TransactionDetail' , -- Name - varchar(128)
          'rptGetActivities_TransactionDetail used for printing' , -- Description - varchar(256)
          '' , -- TaskName - varchar(128)
          '/BusinessManagerReports/rptGetActivities_TransactionDetail' , -- ReportPath - varchar(256)
          NULL , -- ReportParameters - xml
          GETDATE() , -- ModifiedDate - datetime
          '' , -- MenuName - varchar(128)
          '' , -- PermissionValue - varchar(128)
          1  -- PracticeSpecific - bit