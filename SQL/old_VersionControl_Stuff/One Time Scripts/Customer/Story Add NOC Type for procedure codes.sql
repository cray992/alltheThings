

/********** Add a new column to determine codes of Type NOC (Not otherwise qualified codes) *******/
IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'ProcedureCodeDictionary' 
           AND  COLUMN_NAME = 'NOC')
BEGIN
	ALTER TABLE dbo.ProcedureCodeDictionary
	ADD NOC INT DEFAULT(0)
END

GO

UPDATE dbo.ProcedureCodeDictionary
SET noc = 1
WHERE ProcedureCode IN ('A0999',
'A4641',
'A4913',
'A5507',
'A6261',
'A6262',
'A6512',
'A6549',
'A9152',
'A9153',
'A9279',
'A9280',
'A9579',
'A9698',
'A9699',
'A9999',
'B9998',
'B9999',
'C2698',
'C2699',
'C9399',
'E0446',
'E0625',
'E0676',
'E0769',
'E0770',
'E1229',
'E1239',
'E1699',
'E2399',
'E2599',
'G0235',
'G8594',
'G8599',
'G8632',
'G8635',
'G8638',
'G8641',
'G8689',
'G9012',
'G9055',
'G9062',
'G9067',
'G9070',
'G9083',
'G9089',
'G9095',
'G9099',
'G9104',
'G9108',
'G9112',
'G9117',
'G9130',
'G9131',
'G9138',
'G9139',
'H0046',
'H0047',
'J0833',
'J1566',
'J1599',
'J3301',
'J3490',
'J3590',
'J7192',
'J7199',
'J7599',
'J7699',
'J7799',
'J8498',
'J8499',
'J8597',
'J8999',
'J9999',
'K0108',
'K0812',
'K0898',
'L0999',
'L1499',
'L2999',
'L3649',
'L3999',
'L5999',
'L7499',
'L8039',
'L8048',
'L8499',
'L8699',
'Q0181',
'Q2039',
'Q4050',
'Q4082',
'Q4096',
'Q4100',
'Q5009',
'S2409',
'S4015',
'S5130',
'S5131',
'S5181',
'S5199',
'S5497',
'S8189',
'S8301',
'S9379',
'S9445',
'S9446',
'S9542',
'S9810',
'S9976',
'S9977',
'T1505',
'T1999',
'T2025',
'T2028',
'T2029',
'T2032',
'T2033',
'T5999',
'V2199',
'V5090',
'V5274',
'V5298',
'00120',
'00140',
'00160',
'00170',
'0019T',
'00190',
'00210',
'00300',
'00320',
'00350',
'00400',
'00450',
'00470',
'00520',
'00540',
'00600',
'00620',
'00630',
'00700',
'00750',
'00790',
'00800',
'00830',
'00834',
'00836',
'00840',
'00860',
'00880',
'00910',
'00920',
'00940',
'0101T',
'01210',
'01230',
'01270',
'01400',
'01430',
'01440',
'01470',
'01480',
'01500',
'01520',
'01630',
'01650',
'01680',
'01710',
'01740',
'01770',
'01780',
'01830',
'01840',
'01850',
'01924',
'01930',
'01999',
'15999',
'17999',
'19499',
'20999',
'21089',
'21299',
'21499',
'21899',
'22899',
'22999',
'23929',
'24999',
'25999',
'26989',
'27299',
'27599',
'27899',
'28899',
'29799',
'29999',
'30999',
'31299',
'31588',
'31599',
'31899',
'32999',
'33999',
'36299',
'36592',
'37501',
'37799',
'38129',
'38589',
'38999',
'39499',
'39599',
'40799',
'40899',
'41599',
'41899',
'42299',
'42699',
'42999',
'43289',
'43499',
'43659',
'43999',
'44238',
'44799',
'44899',
'44979',
'45499',
'45999',
'46999',
'47379',
'47399',
'47579',
'47999',
'48999',
'49329',
'49659',
'49999',
'50549',
'50949',
'51999',
'53899',
'54699',
'55559',
'55899',
'58578',
'58579',
'58679',
'58999',
'59897',
'59898',
'59899',
'60659',
'60699',
'64722',
'64999',
'66999',
'67299',
'67399',
'67599',
'67999',
'68399',
'68899',
'69399',
'69799',
'69949',
'69979',
'76496',
'76497',
'76498',
'76499',
'76999',
'77299',
'77399',
'77499',
'77799',
'78099',
'78199',
'78299',
'78399',
'78499',
'78599',
'78699',
'78799',
'78999',
'79999',
'80299',
'81099',
'82205',
'82486',
'82487',
'82488',
'82489',
'82491',
'82541',
'82542',
'82543',
'82544',
'82657',
'82658',
'82664',
'83520',
'83788',
'83789',
'83883',
'83986',
'84311',
'84591',
'84999',
'85397',
'85999',
'86317',
'86329',
'86356',
'86486',
'86609',
'86671',
'86682',
'86753',
'86790',
'86849',
'86999',
'87299',
'87449',
'87450',
'87797',
'87798',
'87799',
'87899',
'87999',
'88099',
'88199',
'88299',
'88399',
'88749',
'89240',
'89398',
'90399',
'90749',
'90899',
'90999',
'91299',
'92499',
'92700',
'93799',
'94799',
'95199',
'95999',
'96379',
'96549',
'96999',
'97039',
'97139',
'97760',
'97799',
'99199',
'99429',
'99499',
'99600'
)