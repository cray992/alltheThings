BEGIN TRAN


--DROP TABLE dbo.MiniProfilers
--DROP TABLE dbo.MiniProfilerTimings

--SELECT DISTINCT(databaseservername) FROM SHAREDSERVER.superbill_shared.dbo.Customer
--ORDER BY DatabaseServerName DESC

create table MiniProfilers
  (
     Id                                   uniqueidentifier not null primary key,
     Name                                 varchar(200) not null,
     
     Level                                tinyint null,
     RootTimingId                         uniqueidentifier null,
     DurationMilliseconds                 decimal(7, 1) not null,
     --DurationMillisecondsInSql            decimal(7, 1) null,
     --HasSqlTimings                        bit not null,
     --HasDuplicateSqlTimings               bit not null,
     HasTrivialTimings                    bit not null,
     HasAllTrivialTimings                 bit not null,
     TrivialDurationThresholdMilliseconds decimal(5, 1) null,
     --HasUserViewed                        bit not null,
     
     CustomerId								INT NOT NULL,
     UserId									INT NOT NULL,
     StartedUtc								DATETIME NOT NULL,
     DatabaseName							VARCHAR(30),
     MachineName							VARCHAR(30),
     ApplicationName						VARCHAR(30)
  );

create table MiniProfilerTimings
  (
     RowId                               integer primary key identity, -- sqlite: replace identity with autoincrement
     Id                                  uniqueidentifier not null,
     MiniProfilerId                      uniqueidentifier not null,
     ParentTimingId                      uniqueidentifier null,
     Name                                varchar(200) not null,
     Depth                               smallint not null,
     StartMilliseconds                   decimal(7, 1) not null,
     DurationMilliseconds                decimal(7, 1) not null,
     DurationWithoutChildrenMilliseconds decimal(7, 1) not null,
     --SqlTimingsDurationMilliseconds      decimal(7, 1) null,
     IsRoot                              bit not null,
     HasChildren                         bit not null,
     IsTrivial                           bit not null,
     IsSql								 bit NOT null,
     
     CustomerId								INT NOT NULL,
     UserId									INT NOT NULL,
     StartedUtc								DATETIME NOT NULL,
     DatabaseName							VARCHAR(30),
     MachineName							VARCHAR(30),
     ApplicationName						VARCHAR(30)
     
     --HasSqlTimings                       bit not null,
     --HasDuplicateSqlTimings              bit not null,
     --ExecutedReaders                     smallint not null,
     --ExecutedScalars                     smallint not null,
     --ExecutedNonQueries                  smallint not null
  );
  
ROLLBACK  