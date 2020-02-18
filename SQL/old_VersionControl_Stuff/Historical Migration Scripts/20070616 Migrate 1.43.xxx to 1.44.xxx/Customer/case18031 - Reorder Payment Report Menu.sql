
-------------------------------------------------------------
-- Case 18031:   If time allows, re-order list of reports in menu Reports -> Payments    	  
--------------------------------------------------------------
Declare @ReportOrder Table( ReportID INT, DisplayOrder INT, Name varchar(128) )
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 5,	10,	'Payments Summary'		)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 6,	20,	'Payments Detail'		)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 46,	30,	'Payments Application Summary'	)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 50,	40,	'Adjustments Summary'	)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 49,	50,	'Adjustments Detail'	)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 55,	60,	'Denials Summary'		)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 56,	70,	'Denials Detail'	)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 44,	80,	'Payer Mix Summary'	)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 43,	90,	'Payment by Procedure'	)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 30,	100,	'Missed Copays'	)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 7,	110,	'Payments Application'	)
insert into @ReportOrder( ReportID, DisplayOrder, Name )
values( 57,	120,	'Payment Receipt'	)




update R
SET DisplayOrder = ro.DisplayOrder,
	ModifiedDate = getdate()
FROM @ReportOrder ro
	INNER JOIN Report R on ro.Name = r.Name


GO


GO


