-- Carriage return delete from notes
SELECT REPLACE(Replace(CAST(a.Notes AS VARCHAR(MAX)),CHAR(10),''),CHAR(13),'')AS notes2,a.*
FROM dbo.Appointment a
WHERE a.CreatedDate > DATEADD(mi, -1, GETDATE());
