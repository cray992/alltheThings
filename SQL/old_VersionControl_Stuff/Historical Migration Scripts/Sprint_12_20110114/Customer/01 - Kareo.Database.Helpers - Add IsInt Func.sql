DECLARE @content VARBINARY(MAX)
SET @content = 0x4D5A90000300000004000000FFFF0000B800000000000000400000000000000000000000000000000000000000000000000000000000000000000000800000000E1FBA0E00B409CD21B8014CCD21546869732070726F6772616D2063616E6E6F742062652072756E20696E20444F53206D6F64652E0D0D0A2400000000000000504500004C0103008100004D0000000000000000E00002210B010800000C00000006000000000000EE2B0000002000000040000000004000002000000002000004000000000000000400000000000000008000000002000000000000030040850000100000100000000010000010000000000000100000000000000000000000942B000057000000004000009803000000000000000000000000000000000000006000000C00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000080000000000000000000000082000004800000000000000000000002E74657874000000F40B000000200000000C000000020000000000000000000000000000200000602E72737263000000980300000040000000040000000E0000000000000000000000000000400000402E72656C6F6300000C0000000060000000020000001200000000000000000000000000004000004200000000000000000000000000000000D02B0000000000004800000002000500E0210000B40900000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000660F00280E00000A0F01280E00000A280F00000A731000000A2A820F00280E00000A0F01280E00000A0F02280E00000A281100000A731200000A2A1E02281300000A2A001330020023000000010000110F00281400000A2C067E1500000A2A0F00280E00000A1200281600000A281700000A2A001330020023000000020000110F00281400000A2C067E1500000A2A0F00280E00000A1200281800000A281700000A2A1E02281300000A2A001330050075000000030000117E1900000A0A0F00280E00000A7201000070281A00000A1D1200281B00000A2D067E1C00000A2A067E1D00000A0B1201281E00000A281F00000A2C0E7E1D00000A0C1202281E00000A0A067E2000000A0D1203281E00000A282100000A2C0F7E2000000A13041204281E00000A0A06732200000A2A0000001330020023000000040000110F00281E00000A0A1200282300000A2D0772130000702B057217000070282400000A2A00133002001A000000040000110F00FE16030000016F2500000A282600000A0A06732200000A2A1E02281300000A2A000042534A4201000100000000000C00000076322E302E35303732370000000005006C00000088030000237E0000F40300006804000023537472696E6773000000005C0800001C0000002355530078080000100000002347554944000000880800002C01000023426C6F620000000000000002000001471502000900000000FA2533001600000100000019000000040000000A0000000A000000260000001100000004000000010000000300000000000A00010000000000060063005C000A008B0076000A00960076000A00CF0076000600620150010600790150010600960150010600B50150010600CE0150010600E701500106000202500106001D0250010600550236020600690250010600A20282020600C20282020A001103F6020E004F033003060076035C00060091035C00060097035C000600BE03A9030600DF035C000600EF03A903060053045C0000000000010000000000010001000100100024000000050001000100010010003400000005000100040001001000450000000500010007005020000000009600A0000A0001006A20000000009600AB00130003008B20000000008618B8001E0006009420000000009600BE0022000600C420000000009600C80022000700F320000000008618B8001E000800FC20000000009600DB00290008008021000000009600EC0030000900B021000000009600060129000A00D621000000008618B8001E000B00000001001501000002001B01000001001501000002002301000003003001000001003F01000001003F01000001004101000001004B01000001004B012900B80037003100B80037003900B80037004100B80037004900B80037005100B80037005900B80037006100B80037006900B8003C007100B80037007900B80041008100B8001E008900B8001E00190026034B00910055034F001100B8003C0091005D0355001900B80037000900B8001E00190065035C0011007003600099007C036400110085036B00A1007C037500A900A0038000B100CA038400A900FE03890021000C0496002100A0039600210026039A00A90011049F0021001D049600A90026049F002100B800A700A90035045C0019008503BA0009004A044B00C9005B04C50020006B0046002E001300E6002E001B00E6002E0063000D012E000B00CB002E003300EC002E005B0004012E002B00CB002E002300E6002E003B00E6002E004B00E60040006B00460080006B004600A0006B004600E0006B00460000016B00460020016B00460071007C00AD00C00004800000010000009A0FC062000000000000E0020000020000000000000000000000010053000000000002000000000000000000000001006A000000000002000000000000000000000001005C000000000000000000003C4D6F64756C653E004B6172656F2E44617461626173652E48656C7065722E646C6C00537472696E6746756E6374696F6E73004E756D6572696346756E6374696F6E73004461746546756E6374696F6E73006D73636F726C69620053797374656D004F626A6563740053797374656D2E446174610053797374656D2E446174612E53716C54797065730053716C426F6F6C65616E0053716C537472696E670052656765784D617463680052656765785265706C616365002E63746F72004973496E74656765720049734C6F6E670053716C4461746554696D65004461746546726F6D595959594D4D4444004765744461796C696768744F725374616E6461726454696D65004461746546726F6D537472696E6700696E707574007061747465726E006D617463685061747465726E007265706C6163655061747465726E0073006461746556616C756500646174650053797374656D2E5265666C656374696F6E00417373656D626C795469746C6541747472696275746500417373656D626C794465736372697074696F6E41747472696275746500417373656D626C79436F6E66696775726174696F6E41747472696275746500417373656D626C79436F6D70616E7941747472696275746500417373656D626C7950726F6475637441747472696275746500417373656D626C79436F7079726967687441747472696275746500417373656D626C7954726164656D61726B41747472696275746500417373656D626C7943756C747572654174747269627574650053797374656D2E52756E74696D652E496E7465726F70536572766963657300436F6D56697369626C6541747472696275746500417373656D626C7956657273696F6E4174747269627574650053797374656D2E52756E74696D652E436F6D70696C6572536572766963657300436F6D70696C6174696F6E52656C61786174696F6E734174747269627574650052756E74696D65436F6D7061746962696C697479417474726962757465004B6172656F2E44617461626173652E48656C706572004D6963726F736F66742E53716C5365727665722E5365727665720053716C46756E6374696F6E417474726962757465006765745F56616C75650053797374656D2E546578742E526567756C617245787072657373696F6E730052656765780049734D61746368005265706C616365006765745F49734E756C6C0046616C736500496E743332005472795061727365006F705F496D706C6963697400496E743634004461746554696D65004D696E56616C75650053797374656D2E476C6F62616C697A6174696F6E0043756C74757265496E666F006765745F496E76617269616E7443756C747572650049466F726D617450726F7669646572004461746554696D655374796C65730054727950617273654578616374004E756C6C006F705F4C6573735468616E004D617856616C7565006F705F477265617465725468616E0049734461796C69676874536176696E6754696D6500546F537472696E6700436F6E7665727400546F4461746554696D65000000001179007900790079004D004D006400640000035300000344000000E0F274C3EB524C4CA68E0B357A9F667F0008B77A5C561934E0890800021109110D110D0A0003110D110D110D110D032000010600011109110D0600011111110D060001110D1111042001010E0420010102042001010804010000000320000E050002020E0E0600030E0E0E0E0320000203061109060002020E100805000111090203070108060002020E100A0307010A0306115504000012590C0005020E0E125D116110115503061111042000115507000202115511550520010111550C070511551111111111111111050001110D0E040701115505000111550E1A0100154B6172656F2E44617461626173652E48656C706572000005010000000017010012436F7079726967687420C2A920203230303600000801000800000000001E01000100540216577261704E6F6E457863657074696F6E5468726F777301BC2B00000000000000000000DE2B0000002000000000000000000000000000000000000000000000D02B00000000000000000000000000000000000000005F436F72446C6C4D61696E006D73636F7265652E646C6C0000000000FF250020400000000000000000000000000000000000000000000000000000000100100000001800008000000000000000000000000000000100010000003000008000000000000000000000000000000100000000004800000058400000400300000000000000000000400334000000560053005F00560045005200530049004F004E005F0049004E0046004F0000000000BD04EFFE0000010000000100C0629A0F00000100C0629A0F3F000000000000000400000002000000000000000000000000000000440000000100560061007200460069006C00650049006E0066006F00000000002400040000005400720061006E0073006C006100740069006F006E00000000000000B004A0020000010053007400720069006E006700460069006C00650049006E0066006F0000007C0200000100300030003000300030003400620030000000540016000100460069006C0065004400650073006300720069007000740069006F006E00000000004B006100720065006F002E00440061007400610062006100730065002E00480065006C00700065007200000040000F000100460069006C006500560065007200730069006F006E000000000031002E0030002E0033003900390034002E00320035003200380030000000000054001A00010049006E007400650072006E0061006C004E0061006D00650000004B006100720065006F002E00440061007400610062006100730065002E00480065006C007000650072002E0064006C006C0000004800120001004C006500670061006C0043006F007000790072006900670068007400000043006F0070007900720069006700680074002000A90020002000320030003000360000005C001A0001004F0072006900670069006E0061006C00460069006C0065006E0061006D00650000004B006100720065006F002E00440061007400610062006100730065002E00480065006C007000650072002E0064006C006C0000004C0016000100500072006F0064007500630074004E0061006D006500000000004B006100720065006F002E00440061007400610062006100730065002E00480065006C00700065007200000044000F000100500072006F006400750063007400560065007200730069006F006E00000031002E0030002E0033003900390034002E00320035003200380030000000000048000F00010041007300730065006D0062006C0079002000560065007200730069006F006E00000031002E0030002E0033003900390034002E0032003500320038003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000C000000F03B00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

IF NOT EXISTS (SELECT NAME FROM sys.assemblies WHERE name = 'Kareo.Database.Helper')
BEGIN
	-- CREATE IF NOT EXISTS
	CREATE ASSEMBLY [Kareo.Database.Helper]
	AUTHORIZATION [dbo]
	FROM @content
	WITH PERMISSION_SET = SAFE
END
ELSE IF EXISTS (SELECT TOP 1 NAME FROM sys.assembly_files WHERE name = 'Kareo.Database.Helper' AND content <> @content)
BEGIN
	-- ALTER IF DIFFERENT THAN EXISTING.  Otherwise is errors out with an 'identical' assmbley error.
	ALTER ASSEMBLY [Kareo.Database.Helper]
	FROM @content
	WITH PERMISSION_SET = SAFE
END
GO
