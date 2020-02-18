IF EXISTS (

      SELECT      *

      FROM  SYSOBJECTS

      WHERE Name = 'BillDataProvider_GetPrefetchedFileCmd'

      AND   TYPE = 'P'

)

      DROP PROCEDURE dbo.BillDataProvider_GetPrefetchedFileCmd

GO

 

--===========================================================================

-- GET PREFETCHED FILE

--===========================================================================

CREATE PROCEDURE dbo.BillDataProvider_GetPrefetchedFileCmd

      @filename varchar(256)

AS

BEGIN

 

      SELECT  PrefetcherFileId,

            data,

            ResponseType,

            SourceAddress,

            [FileName],

            FileReceiveDate,

            FileStorageLocation

--    FROM   KareoBizclaims..PrefetcherFile

      FROM   [BIZCLAIMSDBSERVER].KareoBizclaims.dbo.PrefetcherFile

      WHERE [FileName] = @filename

END

GO
