if not exists(select * from documentLabelType where DocumentLabelTypeID = 26)
BEGIN
	INSERT INTO DocumentLabelType (DocumentLabelTypeID, Name, [Description], SortOrder) 
	values (26, 'Eligibility', 'Eligibility', 35)
END
