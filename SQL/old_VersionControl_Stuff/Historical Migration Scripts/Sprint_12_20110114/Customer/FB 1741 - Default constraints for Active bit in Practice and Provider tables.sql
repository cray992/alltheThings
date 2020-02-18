
/****PRACTICE*****/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Practice_Active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Practice] DROP CONSTRAINT [DF_Practice_Active]
END

ALTER TABLE [dbo].[Practice] ADD  CONSTRAINT [DF_Practice_Active]  
DEFAULT (0) 
FOR [Active]

/****PROVIDER*****/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Doctor_ActiveDoctor]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Doctor] DROP CONSTRAINT [DF_Doctor_ActiveDoctor]
END


ALTER TABLE [dbo].[Doctor] 
ADD  CONSTRAINT [DF_Doctor_ActiveDoctor]  
DEFAULT (0) FOR [ActiveDoctor]
GO

