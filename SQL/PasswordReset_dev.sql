-- Reset dev password

USE superbill_shared
GO
UPDATE up
SET passwordcrypt = '$s0$e0801$KiTdRKV0zmyocpoEyGdnxw==$zlgfuggFovZhcqtVQb+W520PmJDtr/G8dHGdJdivjVo='
FROM dbo.Users AS U
INNER JOIN dbo.UserPassword AS UP ON U.UserPasswordID = UP.UserPasswordID
WHERE Expired = 0 AND EmailAddress = 'trevor@kareo.com'
UPDATE dbo.Users
SET AccountLockCounter = 0, AccountLocked = 0
WHERE EmailAddress = 'trevor@kareo.com'
