IF EXISTS ( SELECT  *
                FROM    sys.tables
                WHERE   name = 'HL7_ProcessingLogEntry' )
BEGIN
	DROP TABLE HL7_ProcessingLogEntry
END