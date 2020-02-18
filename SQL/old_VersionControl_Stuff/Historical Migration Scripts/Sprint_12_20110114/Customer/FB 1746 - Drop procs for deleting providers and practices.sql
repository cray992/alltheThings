IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PracticeDataProvider_DeletePractice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PracticeDataProvider_DeletePractice]
GO