USE superbill_26979_prod
GO
BEGIN TRANSACTION
SET NOCOUNT ON 

--rollback
--commit

PRINT''
PRINT'Updating RYAN-FU'
UPDATE atar SET 
atar.AppointmentReasonID=212
--SELECT apr.* 
FROM appointment a 
INNER JOIN dbo.AppointmentToResource ar ON ar.AppointmentID=a.AppointmentID
INNER JOIN dbo.AppointmentToAppointmentReason atar ON atar.AppointmentID=a.AppointmentID
INNER JOIN dbo.AppointmentReason apr ON apr.AppointmentReasonID=atar.AppointmentReasonID
WHERE  --ar.ResourceID=3712 AND 
a.StartDate>'2017-12-04 00:00:00.000' AND 
apr.Name='SON-FU' AND apr.Description='SON-FU'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT''
PRINT'Updating RYAN-BONE SCAN'
UPDATE atar SET 
atar.AppointmentReasonID=213
--SELECT apr.* 
FROM appointment a 
INNER JOIN dbo.AppointmentToResource ar ON ar.AppointmentID=a.AppointmentID
INNER JOIN dbo.AppointmentToAppointmentReason atar ON atar.AppointmentID=a.AppointmentID
INNER JOIN dbo.AppointmentReason apr ON apr.AppointmentReasonID=atar.AppointmentReasonID
WHERE  --ar.ResourceID=3712 AND 
a.StartDate>'2017-12-04 00:00:00.000' AND 
apr.Name='SON-FU-Bone Scan' AND apr.Description='SON-FU-Bone Scan'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT''
PRINT'Updating RYAN-EMG'
UPDATE atar SET 
atar.AppointmentReasonID=214
--SELECT apr.* 
FROM appointment a 
INNER JOIN dbo.AppointmentToResource ar ON ar.AppointmentID=a.AppointmentID
INNER JOIN dbo.AppointmentToAppointmentReason atar ON atar.AppointmentID=a.AppointmentID
INNER JOIN dbo.AppointmentReason apr ON apr.AppointmentReasonID=atar.AppointmentReasonID
WHERE  --ar.ResourceID=3712 AND 
a.StartDate>'2017-12-04 00:00:00.000' AND 
apr.Name='SON-FU-EMG' AND apr.Description='SON-FU-EMG'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT''
PRINT'RYAN-FU HOSP'
UPDATE atar SET 
atar.AppointmentReasonID=215
--SELECT apr.* 
FROM appointment a 
INNER JOIN dbo.AppointmentToResource ar ON ar.AppointmentID=a.AppointmentID
INNER JOIN dbo.AppointmentToAppointmentReason atar ON atar.AppointmentID=a.AppointmentID
INNER JOIN dbo.AppointmentReason apr ON apr.AppointmentReasonID=atar.AppointmentReasonID
WHERE  --ar.ResourceID=3712 AND 
a.StartDate>'2017-12-04 00:00:00.000' AND 
apr.Name='SON-FUNHOSP' AND apr.Description='SON-FUNHOSP'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT''
PRINT'RYAN-FU XRAY'
UPDATE atar SET 
atar.AppointmentReasonID=216
--SELECT apr.* 
FROM appointment a 
INNER JOIN dbo.AppointmentToResource ar ON ar.AppointmentID=a.AppointmentID
INNER JOIN dbo.AppointmentToAppointmentReason atar ON atar.AppointmentID=a.AppointmentID
INNER JOIN dbo.AppointmentReason apr ON apr.AppointmentReasonID=atar.AppointmentReasonID
WHERE  --ar.ResourceID=3712 AND 
a.StartDate>'2017-12-04 00:00:00.000' AND 
apr.Name='SON-FUXRAY' AND apr.Description='SON-FUXRAY'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT''
PRINT'RYAN-PO'
UPDATE atar SET 
atar.AppointmentReasonID=217
--SELECT apr.* 
FROM appointment a 
INNER JOIN dbo.AppointmentToResource ar ON ar.AppointmentID=a.AppointmentID
INNER JOIN dbo.AppointmentToAppointmentReason atar ON atar.AppointmentID=a.AppointmentID
INNER JOIN dbo.AppointmentReason apr ON apr.AppointmentReasonID=atar.AppointmentReasonID
WHERE  --ar.ResourceID=3712 AND 
a.StartDate>'2017-12-04 00:00:00.000' AND 
apr.Name='SON-PO' AND apr.Description='SON-PO'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT''
PRINT'RYAN-ZZ'
UPDATE atar SET 
atar.AppointmentReasonID=218
--SELECT apr.* 
FROM appointment a 
INNER JOIN dbo.AppointmentToResource ar ON ar.AppointmentID=a.AppointmentID
INNER JOIN dbo.AppointmentToAppointmentReason atar ON atar.AppointmentID=a.AppointmentID
INNER JOIN dbo.AppointmentReason apr ON apr.AppointmentReasonID=atar.AppointmentReasonID
WHERE  --ar.ResourceID=3712 AND 
a.StartDate>'2017-12-04 00:00:00.000' AND 
apr.Name='SON-ZZ' AND apr.Description='SON-ZZ'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

----Validation
--SELECT apr.* 
--FROM appointment a 
--INNER JOIN dbo.AppointmentToResource ar ON ar.AppointmentID=a.AppointmentID
--INNER JOIN dbo.AppointmentToAppointmentReason atar ON atar.AppointmentID=a.AppointmentID
--INNER JOIN dbo.AppointmentReason apr ON apr.AppointmentReasonID=atar.AppointmentReasonID
--WHERE  apr.Name LIKE'son%' AND a.StartDate>'2017-12-04 00:00:00.000'
