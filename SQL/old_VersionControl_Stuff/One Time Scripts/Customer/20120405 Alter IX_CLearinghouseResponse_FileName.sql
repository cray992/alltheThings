if exists (select * from dbo.sysindexes where name=('IX_ClearinghouseResponse_FileName'))
ALTER INDEX [IX_ClearinghouseResponse_FileName] ON [dbo].[ClearinghouseResponse] SET ( ALLOW_PAGE_LOCKS  = ON )
ELSE 
RETURN
GO

