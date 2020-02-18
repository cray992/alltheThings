SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[WorkersCompContactDataProvider_GetWorkersCompContacts]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[WorkersCompContactDataProvider_GetWorkersCompContacts]
GO


--===========================================================================
-- GET DOCTORS
--===========================================================================
CREATE PROCEDURE dbo.WorkersCompContactDataProvider_GetWorkersCompContacts
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(50) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON
	
	CREATE TABLE #t_WCContacts(
		[WorkersCompContactInfoID] [int] NOT NULL ,
		[OfficeName] [varchar] (128) NULL ,
		[AddressLine1] [varchar] (256) NULL ,
		[AddressLine2] [varchar] (256) NULL ,
		[City] [varchar] (128) NULL ,
		[State] [varchar] (2) NULL ,
		[Country] [varchar] (32) NULL ,
		[ZipCode] [varchar] (9) NULL ,
		[WorkPhone] [varchar] (20) NULL ,
		[WorkPhoneExt] [varchar] (10) NULL ,
		[FaxPhone] [varchar] (10) NULL ,
		[FaxPhoneExt] [varchar] (10) NULL ,
		[DisplayName] [varchar] (130), 
		[Deletable] [bit] , 
		[RID] [int] IDENTITY (0, 1)
	)

	INSERT INTO #t_WCContacts(
		WorkersCompContactInfoID, 
		OfficeName, 
		AddressLine1, 
		AddressLine2, 
		City, 
		State, 
		Country, 
		ZipCode, 
		WorkPhone, 
		WorkPhoneExt, 
		FaxPhone, 
		FaxPhoneExt, 
		DisplayName,
		Deletable )
	SELECT	WCC.WorkersCompContactInfoID, 
		WCC.OfficeName, 
		WCC.AddressLine1, 
		WCC.AddressLine2, 
		WCC.City, 
		WCC.State, 
		WCC.Country, 
		WCC.ZipCode, 
		dbo.fn_FormatPhone(WCC.WorkPhone),
		WCC.WorkPhoneExt, 
		WCC.FaxPhone, 
		WCC.FaxPhoneExt, 
		WCC.OfficeName,  
		dbo.BusinessRule_WorkersCompContactIsDeletable(WCC.WorkersCompContactInfoID)
	FROM	WorkersCompContactInfo WCC
	WHERE	(	(@query_domain IS NULL OR @query IS NULL)
	OR	(	(@query_domain = 'ID' OR @query_domain = 'All')
				AND (WCC.WorkersCompContactInfoID LIKE '%' + @query + '%'))
	OR	(	(@query_domain = 'OfficeName' OR @query_domain = 'All')
				AND (WCC.OfficeName LIKE '%' + @query + '%'))
	OR 	(	(@query_domain = 'Address' OR @query_domain = 'All')
				AND (WCC.AddressLine1 LIKE '%' + @query + '%'
				OR WCC.AddressLine2 LIKE '%' + @query + '%'
				OR WCC.City LIKE '%' + @query + '%'
				OR WCC.State LIKE '%' + @query + '%'
				OR WCC.ZipCode LIKE '%' + @query + '%'))
	OR 	(	(@query_domain = 'Phone' OR @query_domain = 'All')
				AND (WCC.WorkPhone LIKE '%' + @query + '%'
				OR  WCC.WorkPhoneExt LIKE '%' + @query + '%'))	)
	ORDER BY WCC.OfficeName
	
	SELECT @totalRecords = COUNT(*)
	FROM #t_WCContacts
	
	IF @maxRecords = 0
		SET @maxRecords = @totalRecords
		
	SELECT *
	FROM #t_WCContacts
	WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
	
	DROP TABLE #t_WCContacts
	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

