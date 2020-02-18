IF EXISTS(SELECT * FROM sys.objects WHERE name='ARAGingGraph_Data' AND type='u')
DROP TABLE ARAgingGraph_Data
Go


CREATE TABLE ARAGingGraph_Data(PracticeID INT, TypeGroup VARCHAR(32), CurrentBalance MONEY, Age31_60 MONEY,  Age61_90 MONEY,  Age91_120 MONEY,  AgeOver120 MONEY,  TotalBalance MONEY, DateCreated DATETIME)


CREATE CLUSTERED INDEX [CX_PracticeID_DateCreated] ON [dbo].[ARAGingGraph_Data] 
(
	[PracticeID] ASC,
	[DateCreated] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
