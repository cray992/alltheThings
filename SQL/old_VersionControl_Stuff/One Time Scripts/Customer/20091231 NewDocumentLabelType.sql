-- adding a new label to DocumentLabelType table

declare @name varchar(50)

set @name='Diagnostic Ultrasound'

if not exists (select * from DocumentLabelType where Name=@name)
begin
	insert into DocumentLabelType (DocumentLabelTypeID, Name, [Description], SortOrder) values (21, @name, @name, 180)
end

set @name='Ultrasound'

if not exists (select * from DocumentLabelType where Name=@name)
begin
	insert into DocumentLabelType (DocumentLabelTypeID, Name, [Description], SortOrder) values (22, @name, @name, 180)
end

set @name='Operative Report' 

if not exists (select * from DocumentLabelType where Name=@name)
begin
	insert into DocumentLabelType (DocumentLabelTypeID, Name, [Description], SortOrder) values (23, @name, @name, 180)
end

set @name='History and Physical' 
if not exists (select * from DocumentLabelType where Name=@name)
begin
	insert into DocumentLabelType (DocumentLabelTypeID, Name, [Description], SortOrder) values (24, @name, @name, 180)
end

set @name='Authorization' 
if not exists (select * from DocumentLabelType where Name=@name)
begin
	insert into DocumentLabelType (DocumentLabelTypeID, Name, [Description], SortOrder) values (25, @name, @name, 180)
end

-- update sort order based on Name field
select DocumentLabelTypeID, 10 * Row_Number ( ) OVER (order by Name asc) [Rank]  into #tmp from DocumentLabelType
update DocumentLabelType 
	set SortOrder=t.[Rank]
from DocumentLabelType d
	join #tmp t on t.DocumentLabelTypeID=d.DocumentLabelTypeID
drop table #tmp

-- put Other at the end
update DocumentLabelType set SortOrder=1000 where Name='Other'

