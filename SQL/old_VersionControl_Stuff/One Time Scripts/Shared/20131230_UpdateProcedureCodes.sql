BEGIN TRAN 

CREATE TABLE #tos_codes
    (
      RangeStart VARCHAR(16) NOT NULL ,
      RangeEnd VARCHAR(16) NOT NULL ,
      Tos CHAR(1) NOT NULL
    );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A0021', 'A0999', 'S' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4206', 'A4213', 'S' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4214', 'A4214', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4215', 'A4215', 'L' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4216', 'A4218', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4220', 'A4236', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4244', 'A4247', 'L' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4248', 'A4248', 'L' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4250', 'A4250', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4252', 'A4253', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4254', 'A4254', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4255', 'A4259', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4260', 'A4270', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4280', 'A4280', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4281', 'A4290', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4300', 'A4301', 'S' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4305', 'A4306', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4310', 'A4359', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4360', 'A4360', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4361', 'A4434', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4450', 'A4452', 'L' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4454', 'A4456', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4458', 'A4458', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4460', 'A4463', 'S' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4464', 'A4464', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4465', 'A4466', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4470', 'A4510', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4520', 'A4554', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4556', 'A4565', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4566', 'A4566', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4570', 'A4572', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4575', 'A4590', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4595', 'A4605', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4606', 'A4606', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4608', 'A4613', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4614', 'A4614', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4615', 'A4617', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4618', 'A4618', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4619', 'A4626', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4627', 'A4627', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4628', 'A4628', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4629', 'A4629', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4630', 'A4633', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4634', 'A4634', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4635', 'A4637', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4638', 'A4638', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4639', 'A4640', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4641', 'A4647', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4648', 'A4648', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4649', 'A4649', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4650', 'A4650', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4651', 'A4931', 'L' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A4932', 'A4932', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A5051', 'A5200', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A5500', 'A5513', 'J' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A6000', 'A6000', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A6010', 'A6024', 'S' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A6025', 'A6025', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A6154', 'A6214', 'S' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A6215', 'A6216', 'L' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A6217', 'A6248', 'S' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A6250', 'A6250', 'L' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A6251', 'A6259', 'S' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A6260', 'A6260', 'L' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A6261', 'A6266', 'S' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A6402', 'A6402', 'L' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A6403', 'A6412', 'S' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A6413', 'A6413', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A6421', 'A6512', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A6513', 'A6530', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A6531', 'A6532', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A6533', 'A6544', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A6545', 'A6545', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A6549', 'A6551', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A7000', 'A7002', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A7003', 'A7004', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A7005', 'A7006', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A7007', 'A7008', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A7009', 'A7009', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A7010', 'A7011', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A7012', 'A7012', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A7013', 'A7013', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A7014', 'A7017', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A7018', 'A7018', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A7020', 'A7020', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A7025', 'A7039', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A7040', 'A7043', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A7044', 'A7045', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A7046', 'A7527', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A8000', 'A8004', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9150', 'A9272', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9273', 'A9273', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9274', 'A9280', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9281', 'A9281', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9282', 'A9283', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9284', 'A9284', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9300', 'A9300', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9500', 'A9516', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9517', 'A9517', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9518', 'A9522', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9523', 'A9523', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9524', 'A9529', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9530', 'A9530', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9531', 'A9531', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9532', 'A9532', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9533', 'A9533', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9534', 'A9534', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9535', 'A9542', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9543', 'A9543', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9544', 'A9544', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9545', 'A9545', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9546', 'A9562', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9563', 'A9564', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9565', 'A9580', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9581', 'A9581', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9582', 'A9585', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9600', 'A9605', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9698', 'A9698', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9699', 'A9699', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'A9700', 'A9999', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'B4034', 'B5200', 'E' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'B9000', 'B9006', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'B9998', 'B9999', 'E' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1000', 'C1008', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1009', 'C1009', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1010', 'C1011', '0' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1012', 'C1014', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1015', 'C1018', '0' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1019', 'C1019', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1020', 'C1021', '0' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1022', 'C1022', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1024', 'C1043', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1045', 'C1045', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1047', 'C1048', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1050', 'C1050', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1051', 'C1057', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1058', 'C1058', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1059', 'C1059', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1060', 'C1063', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1064', 'C1066', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1067', 'C1078', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1079', 'C1080', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1081', 'C1081', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1082', 'C1082', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1083', 'C1083', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1084', 'C1086', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1087', 'C1087', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1088', 'C1088', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1089', 'C1099', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1100', 'C1121', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1122', 'C1122', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1123', 'C1154', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1155', 'C1155', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1156', 'C1163', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1164', 'C1164', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1166', 'C1167', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1170', 'C1177', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1178', 'C1178', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1179', 'C1184', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1188', 'C1202', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1203', 'C1203', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1205', 'C1205', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1207', 'C1300', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1302', 'C1304', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1305', 'C1305', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1306', 'C1324', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1325', 'C1325', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1326', 'C1337', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1348', 'C1350', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1351', 'C1359', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1360', 'C1360', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1361', 'C1773', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1774', 'C1774', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1775', 'C1775', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1776', 'C1799', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1800', 'C1806', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C1810', 'C2631', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C2632', 'C2632', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C2633', 'C2633', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C2634', 'C2636', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C2637', 'C2637', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C2638', 'C2638', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C2639', 'C2643', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C2676', 'C2676', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C2698', 'C8936', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C9113', 'C9113', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C9121', 'C9121', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C9248', 'C9248', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C9250', 'C9272', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C9273', 'C9273', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C9274', 'C9274', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C9275', 'C9275', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C9276', 'C9278', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C9279', 'C9287', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C9352', 'C9367', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C9399', 'C9399', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C9406', 'C9406', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C9724', 'C9724', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C9725', 'C9726', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C9727', 'C9732', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'C9800', 'C9899', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D0120', 'D0180', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D0210', 'D0363', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D0415', 'D0999', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D1110', 'D1351', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D1352', 'D1525', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D1550', 'D2710', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D2712', 'D2712', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D2720', 'D2792', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D2794', 'D2794', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D2799', 'D2910', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D2915', 'D2915', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D2920', 'D2933', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D2934', 'D2934', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D2940', 'D2970', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D2971', 'D2975', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D2980', 'D3120', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D3220', 'D3221', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D3230', 'D3348', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D3351', 'D3920', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D3950', 'D3999', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D4210', 'D4276', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D4320', 'D4999', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D5110', 'D5281', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D5410', 'D5761', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D5810', 'D5999', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D6010', 'D6050', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D6053', 'D6079', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D6080', 'D6080', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D6090', 'D6999', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D7110', 'D7282', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D7283', 'D7283', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D7285', 'D7999', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D8010', 'D9110', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D9120', 'D9120', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D9210', 'D9248', '7' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D9310', 'D9310', '3' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D9410', 'D9450', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D9610', 'D9630', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'D9910', 'D9999', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0100', 'E0144', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0145', 'E0146', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0147', 'E0164', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0165', 'E0166', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0167', 'E0168', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0169', 'E0169', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0170', 'E0179', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0180', 'E0182', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0184', 'E0185', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0186', 'E0187', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0188', 'E0189', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0190', 'E0190', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0191', 'E0192', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0193', 'E0196', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0197', 'E0200', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0202', 'E0202', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0203', 'E0203', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0205', 'E0205', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0210', 'E0210', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0215', 'E0230', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0231', 'E0231', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0232', 'E0232', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0235', 'E0236', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0238', 'E0239', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0240', 'E0240', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0241', 'E0249', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0250', 'E0270', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0271', 'E0276', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0277', 'E0277', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0280', 'E0280', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0290', 'E0298', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0300', 'E0300', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0301', 'E0305', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0310', 'E0326', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0328', 'E0329', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0350', 'E0352', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0370', 'E0373', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0424', 'E0431', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0433', 'E0433', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0434', 'E0440', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0441', 'E0444', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0445', 'E0446', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0450', 'E0455', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0457', 'E0457', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0459', 'E0480', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0481', 'E0481', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0482', 'E0483', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0484', 'E0484', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0485', 'E0486', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0487', 'E0487', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0500', 'E0550', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0555', 'E0555', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0560', 'E0562', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0565', 'E0570', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0571', 'E0574', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0575', 'E0575', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0580', 'E0580', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0585', 'E0585', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0590', 'E0590', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0600', 'E0601', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0602', 'E0604', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0605', 'E0605', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0606', 'E0606', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0607', 'E0607', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0608', 'E0608', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0609', 'E0615', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0616', 'E0616', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0617', 'E0617', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0618', 'E0619', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0620', 'E0629', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0630', 'E0636', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0637', 'E0638', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0639', 'E0640', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0641', 'E0673', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0675', 'E0675', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0676', 'E0740', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0744', 'E0745', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0746', 'E0748', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0749', 'E0749', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0751', 'E0754', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0755', 'E0755', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0756', 'E0759', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0760', 'E0760', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0761', 'E0761', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0762', 'E0764', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0765', 'E0765', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0769', 'E0769', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0770', 'E0770', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0776', 'E0776', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0779', 'E0780', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0781', 'E0781', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0782', 'E0783', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0784', 'E0784', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0785', 'E0785', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0786', 'E0786', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0791', 'E0791', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0830', 'E0830', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0840', 'E0840', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0849', 'E0849', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0850', 'E0900', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0910', 'E0941', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0942', 'E0945', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0946', 'E0946', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0947', 'E0957', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0958', 'E0958', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0959', 'E0967', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0968', 'E0968', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0969', 'E0982', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0983', 'E0983', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0984', 'E0986', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0988', 'E0988', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E0990', 'E1030', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1031', 'E1060', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1065', 'E1069', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1070', 'E1160', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1161', 'E1161', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1170', 'E1200', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1210', 'E1213', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1220', 'E1220', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1221', 'E1225', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1226', 'E1227', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1228', 'E1228', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1229', 'E1239', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1240', 'E1295', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1296', 'E1310', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1340', 'E1340', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1353', 'E1353', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1354', 'E1354', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1355', 'E1355', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1356', 'E1372', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1375', 'E1392', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1399', 'E1399', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1400', 'E1406', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1500', 'E1699', 'L' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1700', 'E1700', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1701', 'E1702', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1800', 'E1801', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1802', 'E1802', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1805', 'E1840', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1841', 'E1841', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E1900', 'E1902', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E2000', 'E2000', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E2100', 'E2101', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E2120', 'E2120', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E2201', 'E2396', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E2397', 'E2397', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E2399', 'E2399', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E2402', 'E2402', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E2500', 'E2633', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'E8000', 'E8002', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0001', 'G0001', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0002', 'G0002', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0004', 'G0007', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0008', 'G0009', 'V' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0010', 'G0010', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0015', 'G0016', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0022', 'G0024', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0025', 'G0025', 'S' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0026', 'G0027', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0030', 'G0050', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0101', 'G0102', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0103', 'G0103', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0104', 'G0105', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0106', 'G0106', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0107', 'G0107', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0108', 'G0113', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0114', 'G0114', '3' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0115', 'G0116', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0117', 'G0118', 'Q' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0120', 'G0120', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0121', 'G0121', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0122', 'G0122', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0123', 'G0124', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0125', 'G0126', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0127', 'G0127', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0128', 'G0128', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0129', 'G0129', 'U' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0130', 'G0132', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0141', 'G0148', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0151', 'G0164', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0165', 'G0165', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0166', 'G0168', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0169', 'G0169', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0170', 'G0171', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0172', 'G0172', 'U' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0173', 'G0174', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0175', 'G0175', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0176', 'G0177', 'U' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0178', 'G0178', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0179', 'G0182', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0184', 'G0187', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0188', 'G0188', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0190', 'G0203', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0204', 'G0234', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0235', 'G0235', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0236', 'G0236', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0237', 'G0239', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0240', 'G0240', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0241', 'G0243', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0244', 'G0247', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0248', 'G0249', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0250', 'G0250', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0251', 'G0255', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0256', 'G0256', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0257', 'G0259', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0260', 'G0260', 'F' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0261', 'G0261', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0262', 'G0262', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0263', 'G0264', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0265', 'G0267', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0268', 'G0268', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0269', 'G0272', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0273', 'G0274', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0275', 'G0278', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0279', 'G0283', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0288', 'G0288', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0289', 'G0291', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0292', 'G0292', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0293', 'G0294', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0295', 'G0295', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0296', 'G0296', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0297', 'G0300', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0301', 'G0305', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0306', 'G0307', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0308', 'G0323', 'M' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0324', 'G0327', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0328', 'G0328', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0329', 'G0329', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0332', 'G0332', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0336', 'G0336', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0337', 'G0340', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0341', 'G0343', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0344', 'G0363', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0364', 'G0364', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0365', 'G0368', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0369', 'G0371', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0372', 'G0372', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0373', 'G0376', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0377', 'G0384', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0389', 'G0389', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0390', 'G0390', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0392', 'G0393', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0394', 'G0394', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0396', 'G0397', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0398', 'G0400', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0402', 'G0402', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0403', 'G0405', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0406', 'G0408', '3' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0409', 'G0411', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0412', 'G0415', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0416', 'G0419', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0420', 'G0424', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0425', 'G0427', '3' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0428', 'G0429', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0430', 'G0434', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0435', 'G0435', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0436', 'G0447', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0448', 'G0448', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G0451', 'G9140', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G9141', 'G9142', 'V' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G9143', 'G9143', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G9147', 'G9147', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'G9156', 'G9156', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'H0001', 'H2037', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J0120', 'J0210', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J0215', 'J0215', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J0220', 'J0257', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J0270', 'J0275', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J0278', 'J0476', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J0480', 'J0480', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J0490', 'J0594', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J0595', 'J0595', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J0597', 'J0880', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J0881', 'J0882', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J0885', 'J0885', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J0886', 'J0886', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J0894', 'J1642', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J1644', 'J1644', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J1645', 'J1670', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J1675', 'J1675', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J1680', 'J1820', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J1825', 'J1830', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J1835', 'J2916', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J2920', 'J2930', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J2940', 'J3395', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J3396', 'J3396', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J3400', 'J7180', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J7183', 'J7183', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J7184', 'J7199', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J7300', 'J7307', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J7308', 'J7308', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J7309', 'J7310', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J7311', 'J7311', 'Q' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J7312', 'J7312', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J7315', 'J7324', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J7325', 'J7330', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J7335', 'J7335', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J7340', 'J7349', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J7350', 'J7350', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J7500', 'J7599', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J7604', 'J8499', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J8501', 'J8501', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J8510', 'J8521', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J8530', 'J8530', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J8540', 'J8540', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J8560', 'J8560', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J8561', 'J8561', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J8562', 'J8565', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J8597', 'J8597', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J8600', 'J8600', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J8610', 'J8610', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J8650', 'J8650', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J8700', 'J9212', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J9213', 'J9216', 'G' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'J9217', 'J9999', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0001', 'K0004', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0005', 'K0005', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0006', 'K0007', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0008', 'K0008', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0009', 'K0012', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0013', 'K0013', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0014', 'K0100', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0101', 'K0101', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0102', 'K0108', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0109', 'K0113', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0114', 'K0116', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0119', 'K0123', 'G' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0137', 'K0169', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0170', 'K0171', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0172', 'K0173', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0174', 'K0174', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0175', 'K0176', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0177', 'K0177', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0178', 'K0178', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0179', 'K0181', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0182', 'K0182', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0183', 'K0192', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0193', 'K0195', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0268', 'K0270', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0277', 'K0283', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0284', 'K0284', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0400', 'K0400', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0401', 'K0401', 'J' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0407', 'K0411', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0412', 'K0412', 'G' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0415', 'K0416', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0417', 'K0417', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0418', 'K0418', 'G' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0419', 'K0451', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0452', 'K0452', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0455', 'K0456', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0457', 'K0459', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0460', 'K0461', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0462', 'K0462', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0501', 'K0501', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0503', 'K0529', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0530', 'K0531', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0532', 'K0534', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0535', 'K0537', 'S' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0538', 'K0538', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0539', 'K0540', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0541', 'K0547', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0548', 'K0548', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0549', 'K0550', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0551', 'K0551', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0552', 'K0552', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0553', 'K0555', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0556', 'K0597', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0600', 'K0608', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0609', 'K0609', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0610', 'K0614', 'L' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0615', 'K0617', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0618', 'K0619', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0620', 'K0626', 'S' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0627', 'K0627', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0628', 'K0629', 'J' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0630', 'K0649', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0650', 'K0669', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0670', 'K0670', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0671', 'K0671', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0672', 'K0672', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0730', 'K0730', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0731', 'K0732', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0733', 'K0737', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0738', 'K0738', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0739', 'K0740', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0741', 'K0741', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0742', 'K0742', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0743', 'K0743', 'R' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0744', 'K0746', 'S' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'K0800', 'K0899', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'L0100', 'L3963', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'L3964', 'L3966', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'L3967', 'L3967', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'L3968', 'L3970', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'L3971', 'L3971', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'L3972', 'L3972', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'L3973', 'L3973', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'L3974', 'L3974', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'L3975', 'L8100', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'L8110', 'L8120', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'L8130', 'L9900', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'M0064', 'M0300', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'M0301', 'M0301', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'M0302', 'P7001', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'P9010', 'P9011', '0' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'P9012', 'P9012', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'P9016', 'P9016', '0' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'P9017', 'P9020', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'P9021', 'P9022', '0' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'P9023', 'P9037', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'P9038', 'P9040', '0' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'P9041', 'P9050', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'P9051', 'P9051', '0' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'P9052', 'P9053', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'P9054', 'P9054', '0' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'P9055', 'P9055', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'P9056', 'P9058', '0' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'P9059', 'P9060', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'P9603', 'P9615', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0034', 'Q0034', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0035', 'Q0035', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0068', 'Q0068', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0081', 'Q0081', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0082', 'Q0082', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0083', 'Q0085', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0086', 'Q0086', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0091', 'Q0091', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0092', 'Q0092', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0111', 'Q0115', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0132', 'Q0136', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0137', 'Q0137', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0138', 'Q0139', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0144', 'Q0144', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0156', 'Q0162', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0163', 'Q0181', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0182', 'Q0185', 'S' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0186', 'Q0186', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0187', 'Q0187', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0188', 'Q0188', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0478', 'Q0506', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0510', 'Q0514', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q0515', 'Q0515', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q1001', 'Q1005', 'F' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q2001', 'Q2018', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q2019', 'Q2019', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q2020', 'Q2024', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q2025', 'Q2027', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q2035', 'Q2039', 'V' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q2040', 'Q2040', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q2041', 'Q2042', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q2043', 'Q2043', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q2044', 'Q2044', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q3001', 'Q3001', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q3014', 'Q3014', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q3025', 'Q3026', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q3031', 'Q3031', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q4001', 'Q4051', 'S' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q4052', 'Q4053', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q4054', 'Q4055', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q4074', 'Q4077', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q4078', 'Q4078', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q4079', 'Q4080', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q4081', 'Q4082', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q4083', 'Q4086', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q4087', 'Q4099', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q4115', 'Q4130', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q5001', 'Q9940', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q9941', 'Q9944', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'Q9945', 'Q9968', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'R0070', 'R0075', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'R0076', 'R0076', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0009', 'S0011', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0012', 'S0012', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0014', 'S0087', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0088', 'S0088', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0090', 'S0090', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0091', 'S0093', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0096', 'S0098', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0104', 'S0104', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0106', 'S0108', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0112', 'S0112', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0114', 'S0119', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0122', 'S0132', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0133', 'S0133', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0135', 'S0135', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0136', 'S0169', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0170', 'S0170', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0171', 'S0178', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0179', 'S0179', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0181', 'S0187', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0189', 'S0189', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0190', 'S0201', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0206', 'S0206', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0207', 'S0207', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0208', 'S0215', 'D' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0220', 'S0400', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0500', 'S0592', 'Q' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0595', 'S0800', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0810', 'S0810', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0812', 'S0812', 'Q' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S0820', 'S0830', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S1001', 'S1002', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S1015', 'S1016', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S1025', 'S1025', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S1030', 'S1030', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S1031', 'S1031', 'A' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S1040', 'S1040', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S2050', 'S2053', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S2054', 'S2061', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S2065', 'S2067', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S2068', 'S2109', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S2112', 'S2112', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S2113', 'S2371', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S2400', 'S2404', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S2405', 'S2405', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S2409', 'S2409', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S2411', 'S3800', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S3818', 'S3819', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S3820', 'S4980', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S4981', 'S4981', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S4989', 'S8001', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S8002', 'S8003', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S8004', 'S8035', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S8037', 'S8037', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S8040', 'S8210', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S8260', 'S8260', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S8262', 'S8270', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S8300', 'S8300', 'S' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S8301', 'S8434', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S8450', 'S8452', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S8460', 'S8470', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S8490', 'S8490', 'S' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S8940', 'S9528', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S9529', 'S9529', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S9533', 'S9590', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S9800', 'S9800', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'S9802', 'T1014', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'T1015', 'T1015', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'T1016', 'T4543', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'T5001', 'T5999', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'V2020', 'V2615', 'Q' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'V2623', 'V2629', 'P' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'V2630', 'V2799', 'Q' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'V5008', 'V5299', 'K' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'V5336', 'V5336', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( 'V5362', 'V5364', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '00100', '00103', '7' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '00104', '00104', '7' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '00120', '00860', '7' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '00862', '00862', '7' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '00864', '01999', '7' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '10021', '11012', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '11040', '11044', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '11045', '20525', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '20526', '20527', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '20550', '20975', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '20979', '20979', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '20982', '29058', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '29065', '29540', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '29550', '29550', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '29580', '29580', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '29581', '29582', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '29583', '36410', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '36415', '36415', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '36416', '36416', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '36420', '36510', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '36511', '36516', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '36520', '38200', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '38204', '38204', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '38205', '38206', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '38207', '38209', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '38210', '38210', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '38211', '38215', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '38220', '38241', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '38242', '38242', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '38300', '43774', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '43775', '50290', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '50300', '50320', 'N' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '50323', '50546', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '50547', '50547', 'N' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '50548', '55845', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '55859', '55859', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '55860', '62230', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '62252', '62252', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '62256', '64530', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '64550', '64550', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '64553', '69990', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '70010', '75893', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '75894', '75896', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '75898', '75898', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '75900', '75954', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '75956', '75959', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '75960', '75968', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '75970', '75970', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '75978', '75989', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '75992', '76082', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '76083', '76085', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '76086', '76091', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '76092', '76092', 'B' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '76093', '76934', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '76936', '76936', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '76937', '76937', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '76938', '76938', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '76940', '76940', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '76941', '76942', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '76945', '76945', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '76946', '76965', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '76970', '77051', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '77052', '77052', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '77053', '77056', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '77057', '77057', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '77058', '77084', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '77261', '77370', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '77371', '77373', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '77399', '77423', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '77424', '77425', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '77427', '77435', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '77469', '77469', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '77470', '77799', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '78000', '78264', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '78267', '78268', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '78270', '78807', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '78808', '78808', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '78811', '78999', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '79000', '79001', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '79005', '79005', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '79030', '79100', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '79101', '79101', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '79200', '79440', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '79445', '79445', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '79900', '79999', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '80047', '80440', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '80500', '80502', '3' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '81000', '88319', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '88321', '88332', '3' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '88333', '89399', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '90281', '90468', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '90470', '90470', 'V' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '90471', '90636', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '90644', '90644', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '90645', '90650', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '90654', '90664', 'V' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '90665', '90665', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '90666', '90670', 'V' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '90675', '90727', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '90732', '90732', 'V' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '90733', '90802', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '90804', '90865', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '90867', '90869', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '90870', '90899', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '90901', '90911', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '90918', '90921', 'M' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '90922', '90999', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '91000', '91012', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '91013', '91013', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '91020', '91033', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '91034', '91040', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '91052', '91065', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '91100', '91105', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '91110', '91111', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '91117', '91120', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '91122', '91122', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '91123', '91123', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '91132', '91133', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '91299', '91299', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92002', '92014', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92015', '92015', 'Q' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92018', '92020', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92025', '92025', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92060', '92060', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92065', '92070', 'Q' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92071', '92072', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92081', '92130', 'Q' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92132', '92134', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92135', '92226', 'Q' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92227', '92228', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92230', '92396', 'Q' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92499', '92504', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92506', '92508', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92510', '92510', 'K' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92511', '92520', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92525', '92526', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92531', '92550', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92551', '92557', 'K' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92558', '92558', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92559', '92569', 'K' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92570', '92570', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92571', '92596', 'K' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92597', '92598', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92599', '92616', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92617', '92617', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92618', '92633', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92640', '92640', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92700', '92971', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92973', '92977', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92978', '92979', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '92980', '92998', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '93000', '93278', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '93279', '93292', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '93303', '93352', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '93451', '93463', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '93464', '93464', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '93501', '93545', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '93555', '93556', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '93561', '93662', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '93668', '93668', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '93701', '93744', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '93745', '93750', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '93760', '93888', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '93890', '93893', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '93922', '93981', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '93982', '93982', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '93990', '93998', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '94002', '94005', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '94010', '94450', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '94452', '94610', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '94620', '94621', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '94640', '94668', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '94680', '94772', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '94774', '94774', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '94775', '94776', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '94777', '94777', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '94779', '94799', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '94780', '94781', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '95004', '95801', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '95803', '95830', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '95831', '95852', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '95857', '95870', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '95872', '95927', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '95928', '95929', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '95930', '95930', 'Q' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '95933', '95962', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '95965', '95967', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '95970', '95975', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '95978', '95992', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '95999', '95999', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '96000', '96003', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '96004', '96004', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '96020', '96020', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '96040', '96103', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '96105', '96115', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '96116', '96120', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '96150', '96155', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '96400', '96567', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '96570', '96571', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '96900', '96913', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '96920', '96922', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '96999', '96999', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '97001', '97546', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '97597', '97598', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '97601', '97602', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '97605', '97606', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '97703', '97799', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '97802', '98969', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '99000', '99002', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '99024', '99060', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '99070', '99071', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '99075', '99091', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '99100', '99150', '7' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '99170', '99170', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '99172', '99173', 'Q' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '99174', '99239', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '99241', '99275', '3' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '99281', '99444', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '99450', '99456', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '99460', '99539', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '99551', '99569', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '99600', '99600', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '99601', '99607', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0001F', '0500F', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0501F', '0501F', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0502F', '7025F', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0001T', '0002T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0003T', '0003T', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0005T', '0009T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0010T', '0010T', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0012T', '0020T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0021T', '0021T', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0023T', '0023T', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0024T', '0024T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0025T', '0026T', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0027T', '0027T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0028T', '0028T', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0029T', '0029T', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0030T', '0031T', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0032T', '0039T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0040T', '0040T', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0041T', '0041T', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0042T', '0043T', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0044T', '0045T', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0046T', '0057T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0058T', '0060T', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0061T', '0063T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0064T', '0064T', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0065T', '0065T', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0066T', '0066T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0067T', '0070T', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0071T', '0072T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0073T', '0073T', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0074T', '0074T', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0075T', '0076T', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0077T', '0081T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0082T', '0083T', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0084T', '0084T', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0085T', '0085T', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0086T', '0086T', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0087T', '0087T', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0088T', '0088T', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0089T', '0089T', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0090T', '0102T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0103T', '0110T', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0111T', '0111T', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0115T', '0117T', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0120T', '0126T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0130T', '0133T', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0135T', '0137T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0140T', '0140T', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0141T', '0143T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0145T', '0152T', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0153T', '0153T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0154T', '0154T', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0155T', '0158T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0159T', '0159T', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0160T', '0161T', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0162T', '0162T', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0163T', '0173T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0174T', '0175T', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0176T', '0177T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0178T', '0180T', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0181T', '0181T', 'Q' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0182T', '0182T', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0183T', '0183T', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0184T', '0185T', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0186T', '0186T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0187T', '0190T', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0191T', '0193T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0194T', '0194T', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0195T', '0196T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0197T', '0197T', '6' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0198T', '0199T', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0200T', '0202T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0203T', '0207T', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0208T', '0222T', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0223T', '0225T', '4' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0226T', '0232T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0233T', '0233T', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0234T', '0238T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0239T', '0244T', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0245T', '0259T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0260T', '0261T', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0262T', '0271T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0272T', '0273T', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0274T', '0277T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0278T', '0278T', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0279T', '0281T', '5' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0282T', '0284T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0285T', '0287T', '9' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0288T', '0288T', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0289T', '0290T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0291T', '0292T', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0293T', '0294T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0295T', '0299T', '1' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0300T', '0300T', '2' );

INSERT  INTO #tos_codes
        ( RangeStart, RangeEnd, Tos )
VALUES  ( '0301T', '0301T', '1' );

UPDATE dbo.ProcedureCodeDictionary
SET TypeOfServiceCode = COALESCE(tos.tos,'1'), OfficialName = [short description], officialdescription = [long description]
FROM dbo.ProcedureCodeDictionary AS PCD
JOIN dbo.ProcedureCodes2014 AS H ON pcd.ProcedureCode = h.HCPC
LEFT JOIN #tos_codes AS tos ON h.hcpc BETWEEN tos.rangestart AND tos.rangeend

INSERT INTO dbo.ProcedureCodeDictionary
        ( ProcedureCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          TypeOfServiceCode ,
          Active ,
          OfficialName ,
          LocalName ,
          OfficialDescription
        )
SELECT  hcpc, -- ProcedureCode - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          coalesce(tos.tos,'1') , -- TypeOfServiceCode - char(1)
          1, -- Active - bit
          COALESCE([SHORT DESCRIPTION], [LONG DESCRIPTION]) , -- OfficialName - varchar(300)
          null , -- LocalName - varchar(100)
          [LONG DESCRIPTION]  -- OfficialDescription - varchar(1200)
FROM dbo.ProcedureCodes2014 AS H
LEFT JOIN #tos_codes AS tos ON h.hcpc BETWEEN tos.rangestart AND tos.rangeend
WHERE h.hcpc NOT IN (SELECT procedurecode FROM dbo.ProcedureCodeDictionary AS PCD)

--UPDATE dbo.ProcedureCodeDictionary
--SET Active = 0
--FROM dbo.ProcedureCodeDictionary AS PCD
--WHERE ProcedureCode NOT IN (SELECT HCPC FROM dbo.ProcedureCodes2014 AS PC)
--AND Active = 1

drop table #tos_codes



ROLLBACK TRAN
--drop table ProcedureCodes2014

