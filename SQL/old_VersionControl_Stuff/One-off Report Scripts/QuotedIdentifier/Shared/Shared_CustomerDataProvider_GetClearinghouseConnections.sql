if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Shared_CustomerDataProvider_GetClearinghouseConnections]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
		PRINT 'Dropping Procedure Shared_CustomerDataProvider_GetClearinghouseConnections'
		drop procedure [dbo].[Shared_CustomerDataProvider_GetClearinghouseConnections]
	END	
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

PRINT 'Creating Procedure Shared_CustomerDataProvider_GetClearinghouseConnections'
GO
CREATE Procedure [dbo].[Shared_CustomerDataProvider_GetClearinghouseConnections]
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(50) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT
AS
BEGIN
	
	CREATE TABLE #t_ClearingConnection(
	[ClearinghouseConnectionID] [int] ,
	[ProductionFlag] [varchar] (10),	
	[ClearinghouseConnectionName] [varchar] (100) ,	
	[SubmitterName] [varchar] (100),
	[SubmitterEtin] [varchar] (50),
	[SubmitterContactName] [varchar](100),
	[SubmitterContactPhone] [varchar](100),
	[SubmitterContactEmail] [varchar](100),
	[SubmitterContactFax] [varchar](100),
	[ReceiverName] [varchar] (100),
	[ReceiverEtin] [varchar] (50),
	[ClaimLogin] [varchar] (50),
	[ClaimPassword] [varchar] (50),	
	[Notes] [text],
	RID int IDENTITY(0,1)  
	)
	
	INSERT #t_ClearingConnection(
		ClearinghouseConnectionID,
		ProductionFlag,
		ClearinghouseConnectionName,
		SubmitterName,
		SubmitterEtin,
		SubmitterContactName,
		SubmitterContactPhone,
		SubmitterContactEmail,
		SubmitterContactFax,
		ReceiverName,
		ReceiverEtin,
		ClaimLogin,
		ClaimPassword,
		Notes
	)
	SELECT	
		ClearinghouseConnectionID,

		(CASE (ProductionFlag)
				WHEN 1 THEN 'yes'
				ELSE 'no'
				END) AS ProductionFlag,
		ClearinghouseConnectionName,
		SubmitterName,
		SubmitterEtin,
		SubmitterContactName,
		SubmitterContactPhone,
		SubmitterContactEmail,
		SubmitterContactFax,
		ReceiverName,
		ReceiverEtin,
		ClaimLogin,
		ClaimPassword,
		Notes
	FROM	ClearinghouseConnection 
	WHERE
		(
			(@query_domain IS NULL OR @query IS NULL)
	--	OR	((@query_domain = 'ClearinghouseConnectionID' OR @query_domain = 'All')
	--		  AND (ClearinghouseConnectionID LIKE '%' + @query + '%'))
		OR	((@query_domain = 'ClearinghouseConnectionName' OR @query_domain = 'All')
			  AND (ClearinghouseConnectionName LIKE '%' + @query + '%'))
		OR	((@query_domain = 'SubmitterName' OR @query_domain = 'All')
			  AND (SubmitterName LIKE '%' + @query + '%'))
		OR	((@query_domain = 'SubmitterName' OR @query_domain = 'All')
			  AND (SubmitterName LIKE '%' + @query + '%'))
		OR	((@query_domain = 'SubmitterEtin' OR @query_domain = 'All')
			  AND (SubmitterEtin LIKE '%' + @query + '%'))
		OR	((@query_domain = 'SubmitterContactName' OR @query_domain = 'All')
			  AND (SubmitterContactName LIKE '%' + @query + '%'))
		OR	((@query_domain = 'SubmitterEtin' OR @query_domain = 'All')
			  AND (SubmitterEtin LIKE '%' + @query + '%'))	   
		)
		
	ORDER BY ClearinghouseConnectionID
	
	SELECT @totalRecords = COUNT(*)
	FROM #t_ClearingConnection
	
	IF @maxRecords = 0
		SET @maxRecords = @totalRecords
		
	SELECT *
	FROM #t_ClearingConnection
	WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
	
	DROP TABLE #t_ClearingConnection
	RETURN

END


GO

GRANT EXEC ON [dbo].[Shared_CustomerDataProvider_GetClearinghouseConnections] TO public

GO
