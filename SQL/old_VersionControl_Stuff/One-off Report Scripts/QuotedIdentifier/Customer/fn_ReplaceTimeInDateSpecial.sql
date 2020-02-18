IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  Name = N'fn_ReplaceTimeInDate')
	DROP FUNCTION fn_ReplaceTimeInDate
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION dbo.fn_ReplaceTimeInDate(@dtDate datetime)
RETURNS varchar(100) AS  
BEGIN 
	DECLARE @TempDate datetime;
	DECLARE @hour int
	DECLARE @minute int
	DECLARE @newTime varchar(12)
	SET @newTime = '12:00'
	set @hour = DATEPART(hh, @dtDate)
	set @minute = DATEPART(n, @dtDate)
	set @TempDate = @dtDate
	--Set @timeOnly = CAST(@hour + ':' + dbo.fn_LPad(@minute,'0',2)
	--For all of the dates that are not at midnight
	if @hour NOT IN (0,12)
	begin
		if @hour between 21 and 23
			set @TempDate = Cast(Convert(varchar(10), @dtDate,101) as datetime) + 1	
	end
	
	set @TempDate = Cast((Convert(varchar(10), @TempDate,101) + ' ' + @newTime) as datetime)
	
	RETURN @TempDate;
END

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON 
GO
