INSERT INTO dbo.[_import_1_1_Policies2]
        ( ID ,
          uniquepatientid ,
          precedence ,
          insurancecompanyname ,
          insuranceplanname ,
          line1 ,
          city ,
          state ,
          zipcode ,
          country
        )
SELECT	  ins.id , -- ID - int
          ins.uniquepatientid , -- uniquepatientid - varchar(max)
          ROW_NUMBER() OVER (PARTITION BY ins.uniquepatientid ORDER BY ins.uniquepatientid, ins.precedence) , -- precedence - varchar(max)
          ins.insurancecompanyname , -- insurancecompanyname - varchar(max)
          ins.insuranceplanname , -- insuranceplanname - varchar(max)
          ins.line1 , -- line1 - varchar(max)
          ins.city , -- city - varchar(max)
          ins.state , -- state - varchar(max)
          ins.zipcode , -- zipcode - varchar(max)
		  ins.country  -- country - varchar(max)
FROM dbo.[_import_1_1_Policies] ins
