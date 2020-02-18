DECLARE @t table (RID int identity(1,1), LongName varchar(100), State char(2))

INSERT INTO @t (LongName, State) VALUES ('American Samoa','AS')
INSERT INTO @t (LongName, State) VALUES ('Guam','GU')
INSERT INTO @t (LongName, State) VALUES ('Northern Mariana Islands','MP')
INSERT INTO @t (LongName, State) VALUES ('Puerto Rico','PR')
INSERT INTO @t (LongName, State) VALUES ('Virgin Islands','VI')

DECLARE @loop int SET @loop = 1
DECLARE @max int SET @max = (SELECT MAX(RID) FROM @t)

WHILE @loop <= @max
BEGIN
	IF NOT EXISTS(SELECT * FROM State WHERE State = (SELECT State FROM @t WHERE RID = @loop))
		INSERT INTO State (State,LongName) SELECT State,LongName FROM @t WHERE RID = @loop

	SET @loop = @loop + 1
END

