-- Temp table to combine insurances
CREATE TABLE #InsuranceCompanyPlanList (ID INT IDENTITY(1,1) PRIMARY KEY , Name VARCHAR(128) , Address1 VARCHAR(128) , Address2 VARCHAR(128) , City VARCHAR(100) , [State] VARCHAR(2) , Zip VARCHAR(9))

INSERT INTO #InsuranceCompanyPlanList
        ( 
		  Name ,
          Address1 ,
          Address2 ,
          City ,
          State ,
          Zip
        )
SELECT DISTINCT
		  patientprimaryinspkgname , -- Name - varchar(128)
          patientprimaryinspkgaddrs1 , -- Address1 - varchar(128)
          patientprimaryinspkgaddrs2 , -- Address2 - varchar(128)
          patientprimaryinspkgcity , -- City - varchar(100)
          patientprimaryinspkgstate , -- State - varchar(2)
          REPLACE(patientprimaryinspkgzip,'-','')  -- Zip - varchar(9)
FROM dbo._import_2_1_CDS961printcsvreportsUpdate i
WHERE patientprimaryinspkgname <> '' AND 
	  patientprimaryinspkgname <> '*SELF PAY*' 

INSERT INTO #InsuranceCompanyPlanList
        ( 
		  Name ,
          Address1 ,
          Address2 ,
          City ,
          State ,
          Zip
        )
SELECT DISTINCT
		  patientsecondaryinspkgname , -- Name - varchar(128)
          patientsecondaryinspkgaddrs1 , -- Address1 - varchar(128)
          patientsecondaryinspkgaddrs2 , -- Address2 - varchar(128)
          patientsecondaryinspkgcity , -- City - varchar(100)
          patientsecondaryinspkgstate , -- State - varchar(2)
          REPLACE(patientsecondaryinspkgzip,'-','')  -- Zip - varchar(9)
FROM dbo._import_2_1_CDS961printcsvreportsUpdate i
WHERE i.patientsecondaryinspkgname <> '' AND 
	  i.patientsecondaryinspkgname <> '*SELF PAY*' AND
	  NOT EXISTS (SELECT * FROM #InsuranceCompanyPlanList icp 
				  WHERE i.patientsecondaryinspkgname = icp.Name AND
						i.patientsecondaryinspkgaddrs1 = icp.Address1 AND
						REPLACE(patientsecondaryinspkgzip,'-','') = icp.Zip) 