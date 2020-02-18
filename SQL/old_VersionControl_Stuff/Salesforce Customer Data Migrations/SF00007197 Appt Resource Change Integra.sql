SELECT  *
FROM    dbo.practice

SELECT  *
FROM    doctor D
WHERE   D.[external] = 0

SELECT  *
FROM    [AppointmentToResource] ATR
WHERE   [ATR].[AppointmentResourceTypeID] = 2

SELECT  *
FROM    [AppointmentResourceType]

SELECT  *
FROM    [PracticeResource]

SELECT  *
FROM    [ProviderType]


--Backup Tables to Change
SELECT  *
INTO    _20070529_Doctor
FROM    [Doctor]

SELECT  *
INTO    _20070529_AppointmentToResource
FROM    dbo.AppointmentToResource

SELECT  *
INTO    _20070529_PracticeResource
FROM    dbo.[PracticeResource]

GO

INSERT  INTO dbo.[Doctor] (
          practiceid
        , [External]
        , [ProviderTypeID]
        , [Degree]
        , [Prefix]
        , [FirstName]
        , [MiddleName]
        , [LastName]
        , [Suffix]
        )
        SELECT  2 as practiceid
              , 0 as [External]
              , 1 AS ProviderType
              , 'PA' as Degree
              , '' AS Prefix
              , 'William' AS FirstName
              , '' AS Middle
              , 'Wonderling' AS LastName
              , '' AS Suffix

SELECT  MAX(DoctorID)
FROM    [Doctor]
--204 is the new doctor id for William
--2 is the PracticeResourceID for William


SELECT  *
FROM    [AppointmentToResource] ATR
WHERE   ATR.ResourceID = 2
        AND [ATR].[AppointmentResourceTypeID] = 2
        AND [PracticeID] = 2
--376 Appts

BEGIN TRAN

UPDATE  ATR
SET     [AppointmentResourceTypeID] = 1
      , ResourceID = 204
FROM    [AppointmentToResource] ATR
WHERE   ATR.ResourceID = 2
        AND [ATR].[AppointmentResourceTypeID] = 2
        AND [PracticeID] = 2
--COMMIT 

BEGIN TRAN

UPDATE  ARDR
SET     [AppointmentResourceTypeID] = 1
      , ResourceID = 204
FROM    [AppointmentReasonDefaultResource] ARDR
WHERE   ARDR.ResourceID = 2
        AND ARDR.[AppointmentResourceTypeID] = 2
--COMMIT 5 Records