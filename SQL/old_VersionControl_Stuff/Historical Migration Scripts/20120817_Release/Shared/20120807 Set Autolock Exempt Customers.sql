UPDATE dbo.Customer SET AutoLocksWhenPastDue = 1
WHERE AutoLocksWhenPastDue = 0

UPDATE dbo.Customer SET AutoLocksWhenPastDue = 0
WHERE CustomerId IN (6435,2281,2434,5972,2963,622,2732,121,2344,2550,2870,4701,5075,1087,2248,1878,1729,1885,2007,1685,1919,2520,2907,122,5944,4451,1266,1485,2795,902,1621,2351,2379,1309,2393,1117,9744,591,801,866,644,1806,1986,5218,7696,3221,544,906,1190,3175,743,114,1255,1312,338,761,3062,1251,5103,5159,2406,1124,2363,803,9864,5972,1411,2798,1012,10199,3523,4600,810,1291,2481,3132,1087,891,5057,2039,3349,6939,4976,5958,3195,4798,7462,2070,2875,10362,10757)
