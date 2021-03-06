USE RedGateSqlScriptsManager -- Specify the database in which the objects will be created.

SET NOCOUNT ON


IF OBJECT_ID('[dbo].[IndexMaintenanceQueue]') IS NULL AND OBJECT_ID('[dbo].[PK_IndexMaintenanceQueue]') IS NULL
BEGIN
	CREATE TABLE [dbo].[IndexMaintenanceQueue](
	[IndexMaintenanceQueueID] int IDENTITY(1,1) NOT NULL CONSTRAINT [PK_IndexMaintenanceQueue] PRIMARY KEY CLUSTERED,
		[DatabaseName] sysname NOT NULL,
		[Defragment] bit NOT NULL,
		[UpdateStatistics] bit NOT NULL,
		[Processed] BIT NOT NULL DEFAULT 0,
		[Created] DATETIME NOT NULL DEFAULT GETDATE()
	)
END
GO




IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'ProcessIndexMaintenanceQueue'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.ProcessIndexMaintenanceQueue
GO

CREATE PROCEDURE ProcessIndexMaintenanceQueue
	@StopDateTime DATETIME
AS
BEGIN

	DECLARE @DatabaseName sysname
	DECLARE @Defragment BIT
	DECLARE @UpdateStatistics BIT
	DECLARE @ID INT

	-- Process only while we're not in core business hours (3:00AM-8:00PM, 3:00-20:00)
	WHILE GETDATE() < @StopDateTime
	BEGIN

		IF (SELECT COUNT(*) FROM dbo.IndexMaintenanceQueue WHERE Processed = 0) = 0
		BEGIN
			BREAK;
		END
		
		SELECT TOP 1 @DatabaseName = DatabaseName,
				@Defragment = Defragment,
				@UpdateStatistics = UpdateStatistics,
				@ID = IndexMaintenanceQueueID
		FROM dbo.IndexMaintenanceQueue
		WHERE Processed = 0
		ORDER BY IndexMaintenanceQueueID

		IF @Defragment = 1
		BEGIN
			
			EXECUTE dbo.IndexOptimize @Databases = @DatabaseName,
				@FragmentationLow = NULL,
				@FragmentationMedium = 'INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
				@FragmentationHigh = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
				@FragmentationLevel1 = 5,
				@FragmentationLevel2 = 30,
				@SortInTempdb = 'Y',
				@LogToTable = 'Y'
					
		END
		
		IF @UpdateStatistics = 1
		BEGIN
		
			EXECUTE dbo.IndexOptimize @Databases = @DatabaseName,
				@FragmentationLow = NULL,
				@FragmentationMedium = NULL,
				@FragmentationHigh = NULL,
				@UpdateStatistics = 'ALL',
				@OnlyModifiedStatistics = 'Y',
				@StatisticsSample = 100,
				@LogToTable = 'Y'
			
		END

		UPDATE dbo.IndexMaintenanceQueue
		SET Processed = 1
		WHERE IndexMaintenanceQueueID = @ID

	END

END
GO