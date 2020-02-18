update BillingInvoicing_Practices
set SupportTypeID = 3
where SupportTypeID in (1, 2)

update Customer
set SupportTypeID = 3
where SupportTypeID in (1, 2)

update CustomerOrderSupport
set SupportTypeID = 3
where SupportTypeID in (1, 2)

update BillingInvoicing_Practices
set SupportTypeID = 6
where SupportTypeID in (7, 8)

update Customer
set SupportTypeID = 6
where SupportTypeID in (7, 8)

update CustomerOrderSupport
set SupportTypeID = 6
where SupportTypeID in (7, 8)

delete from SupportType
where SupportTypeID in (1, 2, 7, 8)

update SupportType
set
	SupportTypeCaption = 'Self-Service',
	ProductCaptionAndPrice = 'Self-Service (free)',
	Sort = 1
where SupportTypeId = 4

update SupportType
set
	SupportTypeCaption = 'Email Support',
	ProductCaptionAndPrice = 'Email Support ($99 per month)',
	Sort = 2
where SupportTypeId = 3

update SupportType
set
	SupportTypeCaption = 'Phone & Email Support',
	ProductCaptionAndPrice = 'Phone & Email Support ($199 per month)',
	Sort = 3
where SupportTypeId = 6