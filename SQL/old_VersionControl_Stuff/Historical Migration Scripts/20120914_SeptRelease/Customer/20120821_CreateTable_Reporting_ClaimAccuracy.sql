IF EXISTS(SELECT *
			FROM Sys.objects AS o WHERE o.name='Reporting_ClaimsAccuracy' AND o.type='u')
DROP TABLE Reporting_ClaimsAccuracy

CREATE  TABLE Reporting_ClaimsAccuracy(BeginDate DateTime,EndDate DAteTime,PracticeiD INT,Rejections INT, Denials INT, Billed INT, RJTBalance MONEY, DenBalance MONEY, BLLBalance MONEY)

CREATE INDEX IX_Reporting_ClaimAccuracy_PracticeID ON Reporting_ClaimsAccuracy(PracticeID ) INCLUDE(Rejections, Denials, Billed,RJTBalance, DenBalance, BLLBalance)