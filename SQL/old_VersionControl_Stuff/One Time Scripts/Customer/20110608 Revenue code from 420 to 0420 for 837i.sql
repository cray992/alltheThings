-- SF 00208466 - Update the existing 420 revenue code for 837i to 0420
UPDATE dbo.RevenueCode SET code='0420' WHERE revenuecodeid=207 AND code='420'

-- SF 00244338 - Update the existing 424 revenue code for 837i to 0424
UPDATE dbo.RevenueCode SET code='0424' WHERE revenuecodeid=211 AND code='424'