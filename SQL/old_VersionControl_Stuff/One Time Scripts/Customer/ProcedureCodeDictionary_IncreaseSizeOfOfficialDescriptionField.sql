--===========================================================================
-- Alter table ProcedureCodeDictionary to accomodate 1200 chars in [OfficialDescription]
--===========================================================================


/****** Object:  Table [dbo].[ProcedureCodeDictionary]    Script Date: 12/29/2006 16:00:20 ******/

ALTER TABLE [dbo].[ProcedureCodeDictionary] ALTER COLUMN [OfficialDescription] [varchar](1200) 


