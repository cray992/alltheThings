if NOT EXISTS (select * from information_schema.columns where table_name = 'ReportCategory' and column_name = 'IsVisible')
begin
	alter table [dbo].[ReportCategory]
	add [IsVisible] BIT 
	CONSTRAINT [DF_ReportCategory_IsVisible] DEFAULT 1 NOT NULL;
end
GO