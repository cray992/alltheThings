USE superbill_14911_prod


IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
              WHERE TABLE_NAME = '_import_4_3_Insurance' AND COLUMN_NAME = 'address1')
BEGIN
  ALTER TABLE [dbo].[_import_4_3_Insurance]  ADD address1 varchar(128) NULL
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = '_import_4_3_Insurance' AND COLUMN_NAME = 'address2')
BEGIN

  ALTER TABLE [dbo].[_import_4_3_Insurance]  ADD address2 varchar(128) NULL
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = '_import_4_3_Insurance' AND COLUMN_NAME = 'city')
BEGIN

  ALTER TABLE [dbo].[_import_4_3_Insurance]  ADD city varchar(128) NULL
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = '_import_4_3_Insurance' AND COLUMN_NAME = 'state')
BEGIN

  ALTER TABLE [dbo].[_import_4_3_Insurance]  ADD state varchar(128) NULL
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = '_import_4_3_Insurance' AND COLUMN_NAME = 'zipcode')
BEGIN

  ALTER TABLE [dbo].[_import_4_3_Insurance]  ADD zipcode varchar(128) NULL
END




UPDATE dbo.[_import_4_3_Insurance]
	SET address1 = addressline1,
		city = inscity,
		state = insstate,
		zipcode = zip 
	FROM (SELECT code, addressline1, 
				REPLACE(LEFT(rest, CHARINDEX(',', rest, 0)), ',', '') AS inscity, 
				LEFT(LTRIM(SUBSTRING(rest, CHARINDEX(',', rest, 0)+1, 255)), 2) AS insstate,
				dbo.fn_RemoveNonNumericCharacters(rest) AS zip ,	address
			FROM(Select code, 
				   REPLACE(LEFT(address, CHARINDEX(',', address, 0)), ',', '') AS addressline1, 
				   SUBSTRING(address, CHARINDEX(',', address, 0)+1, 255) AS rest,   address
			     FROM dbo.[_import_4_3_Insurance]
					WHERE code NOT IN ('AS VEGAS, NV 89119')
					AND address NOT LIKE '%,%,%, %'
			 )blah
		)Blahblah
	WHERE blahblah.code = dbo.[_import_4_3_Insurance].code 


UPDATE dbo.[_import_4_3_Insurance]
	SET address1 = addressline1,
		address2 = addressline2,
		city = inscity,
		state = insstate,
		zipcode = zip 
	FROM (select code, addressline1, addressline2, 
				REPLACE(LEFT(therest,CHARINDEX(',', therest, 0)), ',', '') AS inscity, 
				LEFT(LTRIM(SUBSTRING(therest, CHARINDEX(',', therest)+1, 255)), 2) AS insstate,
				dbo.fn_RemoveNonNumericCharacters(therest) AS zip, address 
		  FROM (Select code, addressline1, 
					REPLACE(LEFT(rest, CHARINDEX(',', rest, 0)), ',', '') AS addressline2,
					SUBSTRING(rest, CHARINDEX(',', rest) + 1, 255) AS therest, address 
				FROM (select code, 
						REPLACE(LEFT(address, CHARINDEX(',', address, 0)), ',', '') AS addressline1,
						SUBSTRING(address, CHARINDEX(',', address)+1, 255) AS rest, address
					   FROM dbo.[_import_4_3_Insurance] WHERE address LIKE  '%,%,%, %'
						and code NOT IN ('ATTORNEYDA', 'ACE', 'ATTYLAUGHL', 'I C S', 'LAWOFF4', 'POACHCONSU', 'UCBERKELEY', 'GRCOVINA', 'LAWOFFI', 'TRUSTPLANS', 'BARTHOL', 'LAWOFFICCA', 'KAISERFOUN', 'TRAVELINS')  
					  ) start
			  	) blah
		 ) total 
	WHERE total.code = dbo.[_import_4_3_Insurance].code 



UPDATE dbo.[_import_4_3_Insurance]
	SET address1 = addressline1a + ' ' + addressline1b,
		address2 = addressline2,
		city = inscity,
		state = insstate,
		zipcode = zipcode
FROM(	SELECT code, addressline1a, addressline1b, addressline2,
			REPLACE(LEFT(rest, CHARINDEX(',', rest, 0)), ',', '') AS inscity,
			LEFT(LTRIM(SUBSTRING(rest, CHARINDEX(',', rest)+1, 255)), 2) AS insstate,
			dbo.fn_RemoveNonNumericCharacters(rest) AS zip, address
			FROM(SELECT code, addressline1a, addressline1b, 
				REPLACE(LEFT(therest, CHARINDEX(',', therest, 0)), ',', '') AS addressline2,
				SUBSTRING(therest, CHARINDEX(',', therest)+1, 255) AS rest, address
				FROM(SELECT code, addressline1a, 
						REPLACE(LEFT(rest, CHARINDEX(',', rest, 0)), ',', '') AS addressline1b, 
						LTRIM(SUBSTRING(rest, CHARINDEX(',', rest)+1, 255)) AS therest, address
					FROM(SELECT code, 
							REPLACE(LEFT(address, CHARINDEX(',', address, 0)), ',', '') AS addressline1a,
							SUBSTRING(address, CHARINDEX(',', address)+1, 255) AS rest, address
							FROM dbo.[_import_4_3_Insurance] WHERE address LIKE  '%,%,%,%,%'
							AND code NOT IN ('KAISERFOUN')
						)blah
					) blahblah
				) sheep
	)black
WHERE black.code = dbo.[_import_4_3_Insurance].code



UPDATE dbo.[_import_4_3_Insurance]
	SET address1 = 'GPO BOX 4065',
		city = 'Sidney',
		state = 'NSW',
		zipcode = '2000'
	WHERE code = 'ACE'
	
UPDATE dbo.[_import_4_3_Insurance]
	SET address1 = 'PO BOX 7004,ATTN  CLAIMS DEPT',
		address2 = 'KAISERPERM KAISER PERMANENTE,5601 DE SOTO AVENUE',
		city = 'WOODLAND HILLS',
		state = 'CA',
		zipcode = '91365'
	WHERE code = 'KAISERFOUN'



/*

SELECT DISTINCT(ins3code) FROM dbo.[_import_4_3_PatientsDemographics]  pat
LEFT JOIN dbo.InsurancePolicy ip ON 
	ip.PolicyNumber = pat.ins3id AND
	ip.GroupNumber = pat.ins3group AND
	ip.vendorid = pat.code
WHERE code <> '' AND pat.ins3code <> '' AND InsurancePolicyID IS NULL 




SELECT * FROM dbo._import_4_3_Insurance
WHERE code IN ('1199SEIUBE','AARLA','AARP2','AARPMEDICA','ABPA','ACCA','ACCE000001','ACCOUNTABL','ACEU000001','ADMINITRAT','ADVANCEBEN',
'ADVANCEDBE','ADVENTIST','AETN000000','AETN000001','AETN000002','AETNA','AETNABISM','AETNACHICK','AETNAEL','AETNAEL2','AETNAEL3','AETNAEL4',
'AETNAFLOR','AETNAFRES','AETNAFRES2','AETNAINS','AETNALEX','AETNALEX3','AETNAMEDI2','AETNAMEDIC','AETNASANAN','AETNASANDI','AETNASC','AETNASD',
'AETNASTUDE','AFFORDBENE','AFFORDCLAS','AFTRA','AGA','AGADMINIST','AGNEW','AIGCLAIMCO','AIGCLAIMS','AIGDE','AIGGEORGIA','AIGHDI',
'AIGNEWOR','AIGPERSONA','AIGPITTS','AIGSANRAMO','AIGSD','AIGSTAANA','AIMS','AIRFORCE','AIU2','AIUHOLDING','ALASKA','ALDERLAW','ALLIEDBENE',
'ALLIEDPHY','ALLSTATE','ALOHA','ALPHAFUND','AMAINSURAN','AMERBEN','AMERIBEN','AMERICACO2','AMERICANAL',
'AMERICANCL','AMERICANCO','AMERICANFI','AMERICANPR','AMERICANSD','AMERICASIM','AMERICMARI','AMERMEDSEC','AMTRUST','AMTRUSTNOR','ANTHEMBL2',
'APPLECARE','APPLIED','APPLIERISK','APWU','APWU2','ARGONAUT','ARGONAUT2','ARGONAUT3','ARGONAUTFR','BENA000002','BLSHIELD10','BLUE',
'BLUE000000','BLUE000003','BSMEDADV','BUNCHCARES','CAMBRIDGL3','CIGNA2','CIGNACHAT2','CITYGLENDA','COLEN','COMMUNITYA','CORVELRC',
'COT','DGA','ELCAMINO','GEMCARE','GREATWEST','GREENBAY','GROUP','GROUPHEALT',
'GUIDEONE','HARTF AUTO','HEALTHCAR2','HIP','IAB','ILLI000001','INTERCARE','INTERCAREH','LADWP','LAWOFF22','LAWOFF32','LBAHEALTH',
'MATSON','MEDICA','MERITAIN','MVPHEALTHC','MYERS','NALCHEALT2','NEI','NEI2','NORDSTROM','NORTHROP','OPTIMA','PACIFICLEG','PDE',
'PHCS2','PLANAD','PROFESSION',
'ROGER','SEDGLAUSD2','SHEET','SOUT000001','STARMARK','TBA','THEGASCOMP','TIG','TORRANCEME','TRAVELERSO','UNITEDAR','UNITEDHETX',
'UNITEDINTE','UNITEDNY','WAKS M','WARNER','WERNER','WGAINDUSTR')


SELECT code, fullname, ins1code, ins1name, ins1id, ins1group FROM dbo.[_import_4_3_PatientsDemographics] WHERE ins1code IN ('1199SEIUBE','AARLA','AARP2','AARPMEDICA','ABPA','ACCA','ACCE000001','ACCOUNTABL','ACEU000001','ADMINITRAT','ADVANCEBEN',
'ADVANCEDBE','ADVENTIST','AETN000000','AETN000001','AETN000002','AETNA','AETNABISM','AETNACHICK','AETNAEL','AETNAEL2','AETNAEL3','AETNAEL4',
'AETNAFLOR','AETNAFRES','AETNAFRES2','AETNAINS','AETNALEX','AETNALEX3','AETNAMEDI2','AETNAMEDIC','AETNASANAN','AETNASANDI','AETNASC','AETNASD',
'AETNASTUDE','AFFORDBENE','AFFORDCLAS','AFTRA','AGA','AGADMINIST','AGNEW','AIGCLAIMCO','AIGCLAIMS','AIGDE','AIGGEORGIA','AIGHDI',
'AIGNEWOR','AIGPERSONA','AIGPITTS','AIGSANRAMO','AIGSD','AIGSTAANA','AIMS','AIRFORCE','AIU2','AIUHOLDING','ALASKA','ALDERLAW','ALLIEDBENE',
'ALLIEDPHY','ALLSTATE','ALOHA','ALPHAFUND','AMAINSURAN','AMERBEN','AMERIBEN','AMERICACO2','AMERICANAL',
'AMERICANCL','AMERICANCO','AMERICANFI','AMERICANPR','AMERICANSD','AMERICASIM','AMERICMARI','AMERMEDSEC','AMTRUST','AMTRUSTNOR','ANTHEMBL2',
'APPLECARE','APPLIED','APPLIERISK','APWU','APWU2','ARGONAUT','ARGONAUT2','ARGONAUT3','ARGONAUTFR','BENA000002','BLSHIELD10','BLUE',
'BLUE000000','BLUE000003','BSMEDADV','BUNCHCARES','CAMBRIDGL3','CIGNA2','CIGNACHAT2','CITYGLENDA','COLEN','COMMUNITYA','CORVELRC',
'COT','DGA','ELCAMINO','GEMCARE','GREATWEST','GREENBAY','GROUP','GROUPHEALT',
'GUIDEONE','HARTF AUTO','HEALTHCAR2','HIP','IAB','ILLI000001','INTERCAREH','LADWP','LAWOFF22','LAWOFF32','LBAHEALTH',
'MATSON','MEDICA','MERITAIN','MVPHEALTHC','MYERS','NALCHEALT2','NEI','NEI2','NORDSTROM','NORTHROP','OPTIMA','PACIFICLEG','PDE',
'PHCS2','PLANAD','PROFESSION',
'ROGER','SHEET','SOUT000001','STARMARK','TBA','THEGASCOMP','TIG','TORRANCEME','TRAVELERSO','UNITEDAR','UNITEDHETX',
'UNITEDINTE','UNITEDNY','WAKS M','WARNER','WERNER','WGAINDUSTR')



SELECT code, fullname, ins2code, ins2name, ins2id, ins2group FROM dbo.[_import_4_3_PatientsDemographics] WHERE ins2code IN ('BLUE000003',
'EMPLOYEEHE','ADVANCEBEN','AMERICANPI','DARRCA','AFLAC','ALECCIA','AIRCONDI','AETN000000','AIGAMGEN','AARP','AARPUH2','AETN000001',
'AETNALIFE','ILWUACCORD','AMA2','14','AETNAEL4','AARPCALIF','AETNALEX1','AETNAMCSUP','AGIA','AMERREPUBL','AFL','AMERIHEALT','AETNAEL',
'APWUHEALTH','AETNAFLORI','AMERIBEN2','BLUEANTHEM','FARMERS2','ELCAMINO','AETNAINS','APWU','AETNAEL2','BLUE','MYERS','SHEET2','AETNA',
'AETNAGREEN','PRODUCTS','BLUE000000','AGA','AMAINSURAN','TURT000001','AARP2','PLANAD')

SELECT * FROM dbo.[_import_4_3_Insurance] WHERE code IN ('BLUE000003',
'EMPLOYEEHE','ADVANCEBEN','AMERICANPI','DARRCA','AFLAC','ALECCIA','AIRCONDI','AETN000000','AIGAMGEN','AARP','AARPUH2','AETN000001',
'AETNALIFE','ILWUACCORD','AMA2','14','AETNAEL4','AARPCALIF','AETNALEX1','AETNAMCSUP','AGIA','AMERREPUBL','AFL','AMERIHEALT','AETNAEL',
'APWUHEALTH','AETNAFLORI','AMERIBEN2','BLUEANTHEM','FARMERS2','ELCAMINO','AETNAINS','APWU','AETNAEL2','BLUE','MYERS','SHEET2','AETNA',
'AETNAGREEN','PRODUCTS','BLUE000000','AGA','AMAINSURAN','TURT000001','AARP2','PLANAD')


SELECT code, fullname, ins3code, ins2name, ins3id, ins3group FROM dbo.[_import_4_3_PatientsDemographics] WHERE ins3code 
IN ('AARP','AARPUH2','AETN000000','AETN000001','AETNA','AFLAC','BLUE','BLUE000000')

SELECT * FROM dbo.[_import_4_3_Insurance] WHERE code IN ('AARP','AARPUH2','AETN000000','AETN000001','AETNA','AFLAC','BLUE','BLUE000000')


*/