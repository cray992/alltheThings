SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GeneralDataProvider_GetPaymentTypes]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GeneralDataProvider_GetPaymentTypes]
GO


--===========================================================================
-- GET PAGE STATUS TYPES
--===========================================================================
CREATE  PROCEDURE dbo.GeneralDataProvider_GetPaymentTypes
AS
BEGIN
	SELECT	
		PaymentTypeID,
		[Name],
		PayerTypeCode,
		SortOrder
	FROM	
		PaymentType
	ORDER BY
		SortOrder
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

