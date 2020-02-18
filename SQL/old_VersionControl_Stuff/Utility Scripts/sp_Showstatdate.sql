
alter proc sp_Showstatdate @Tabmask sysname='%', @indmask sysname='%'
as 
select
LEFT(cast(User_Name(uid) + '.' + o.name as sysname), 30) as TableName,
LEFT(i.name, 30) as IndexName,
Case when indexproperty(o.id, i.name, 'IsStatistics')=1 THEN 'AutoStatistics' 
	when Indexproperty(o.id, i.name, 'IsStatistics') =1 THEN 'Statistics'
	ELSE 'Index'
	END as Type,
STATS_Date(o.id, i.indid) as StatsUpdate,
rowcnt,
rowmodctr,
ISNULL(Cast(rowmodctr/cast(NULLIF(rowcnt, 0) as decimal(20,2)) * 100 AS INT), 0) as PercentModifiedRows,
Case i.Status & 0x1000000
WHEN 0 THEN 'No'
ELSE 'Yes'
END AS [NoRecompute?],
i.status
FROM dbo.sysobjects o join dbo.sysindexes i on (o.id = i.id)
where o.name like @tabmask
AND i.name like @indmask
and Objectproperty(o.id, 'IsUserTable') = 1
order by LEFT(cast(User_Name(uid) + '.' + o.name as sysname), 30)
GO

sp_Showstatdate