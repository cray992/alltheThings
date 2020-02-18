-- adding a new label to DocumentLabelType table


declare @name varchar(50)

set @name='Prescriptions'

if not exists (select * from DocumentLabelType where Name=@name)
begin
	insert into DocumentLabelType (DocumentLabelTypeID, Name, [Description], SortOrder) values (20, @name, @name, 180)

	-- update sort order based on Name field
	select DocumentLabelTypeID, 10 * Row_Number ( ) OVER (order by Name asc) [Rank]  into #tmp from DocumentLabelType
	update DocumentLabelType 
		set SortOrder=t.[Rank]
	from DocumentLabelType d
		join #tmp t on t.DocumentLabelTypeID=d.DocumentLabelTypeID
	drop table #tmp

	-- put Other at the end
	update DocumentLabelType set SortOrder=1000 where Name='Other'
end

