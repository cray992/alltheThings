-- SF 82201 - Update EditionTypes for old databases
BEGIN TRY
BEGIN TRAN
if exists(select editiontypeid from editiontype where editiontypename = 'Max')
begin

	update editiontype
	set editiontypename='Enterprise'
	where editiontypeid=1
	and editiontypename='Complete'

	update editiontype
	set editiontypename='Team'
	where editiontypeid=2
	and editiontypename='Plus'

	delete from editiontype
	where editiontypeid=7
	and editiontypename='Max'

end
COMMIT TRAN
END TRY
BEGIN CATCH
	IF @@Trancount > 0
		ROLLBACK TRAN
		
END CATCH