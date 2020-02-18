
SET NOCOUNT ON
-- drop table numbers

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Numbers]') AND type in (N'U'))
BEGIN

	create table [Numbers]( Number INT NOT NULL)

	declare @i INT
	SET @i=0
	declare @n table(n int)

	WHILE @i<1000
	BEGIN
		SET @i=@i+1
		
		INSERT INTO @n( n )
		values(@i)

	END

	SET @i=-1
	
	WHILE @i<=1000
	BEGIN
		SET @i=@i+1
		
		INSERT INTO Numbers( number )
		SELECT (@i*1000) + n
		FROM @n

	END


	ALTER TABLE [dbo].[Numbers] ADD  CONSTRAINT [pk_Numbers_number] PRIMARY KEY CLUSTERED 
	(
		[Number] ASC
	)


END