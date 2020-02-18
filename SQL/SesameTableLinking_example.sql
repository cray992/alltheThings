USE SFDC_Sesame;
GO
SET TRAN ISOLATION LEVEL READ UNCOMMITTED;
SET XACT_ABORT ON;

----Current

INSERT INTO SHAREDSERVER.superbill_shared.dbo.sf_enrollment_status_current
(
    id,
    case_number,
    contact_email,
    followup_date,
	last_modified_date,
	cust_id
)
SELECT --TOP 5
    sc.CASENUMBER,
    p.CONTACT_EMAIL_1__C,
    p.FOLLOW_UP_DATE__C,
    p.LASTMODIFIEDDATE,
    p.STATUS__C,
    sa.KAREOCUSTOMERID__C
FROM dbo.SF_PAYER__C p
    INNER JOIN dbo.SF_CASE AS sc
        ON p.CASE__C = sc.ID
    INNER JOIN dbo.SF_USER AS su
        ON sc.OWNERID = su.ID
    INNER JOIN dbo.SF_ACCOUNT AS sa
        ON sc.ACCOUNTID = sa.ID
WHERE
		p.LASTMODIFIEDDATE <>
		(
			SELECT TOP 1
				c.last_modified_date
			FROM SHAREDSERVER.superbill_shared.dbo.sf_enrollment_status_current c
			WHERE c.last_modified_date < p.LASTMODIFIEDDATE
					AND c.id = p.ID
		)
	  AND sc.CREATEDDATE > GETDATE() - 180
      AND sa.KAREOCUSTOMERID__C IS NOT NULL
      AND sc.DELETE_FLAG = 'N'
      AND su.DELETE_FLAG = 'N'
      AND sa.DELETE_FLAG = 'N'
      AND sc.STATUS NOT IN ( 'Cancelled', 'Closed' )
	  ;


----History

INSERT INTO SHAREDSERVER.superbill_shared.dbo.sf_enrollment_status_hist
(
    id,
    createddate,
    lastmodifieddate,
    status_c,
    status_reason,
    followup_date,
    additional_details
)
SELECT --TOP 10
    p.ID,
    p.CREATEDDATE,
    p.LASTMODIFIEDDATE,
    p.STATUS__C,
    p.STATUS_REASON__C,
    p.FOLLOW_UP_DATE__C,
    p.DENIED_REASON__C
--select top 100 p.*
FROM dbo.SF_PAYER__C p
    INNER JOIN dbo.SF_CASE c
        ON c.PAYER_ID__C = p.ID
    INNER JOIN dbo.SF_USER AS su
        ON c.OWNERID = su.ID
    INNER JOIN dbo.SF_ACCOUNT AS sa
        ON c.ACCOUNTID = sa.ID
WHERE p.LASTMODIFIEDDATE <>
(
    SELECT TOP 1
        c.lastmodifieddate
    FROM SHAREDSERVER.superbill_shared.dbo.sf_enrollment_status_hist c
    WHERE c.lastmodifieddate < p.LASTMODIFIEDDATE
          AND c.id = p.ID
)
      AND p.DELETE_FLAG = 'n'
      AND p.CREATEDDATE > GETDATE() - 90
      AND c.STATUS NOT IN ( 'Cancelled', 'Closed' )
      AND c.DELETE_FLAG = 'N'
      AND su.DELETE_FLAG = 'N'
      AND sa.DELETE_FLAG = 'N'
UNION
SELECT --TOP 10
    p.ID,
    p.CREATEDDATE,
    p.LASTMODIFIEDDATE,
    p.STATUS__C,
    p.STATUS_REASON__C,
    p.FOLLOW_UP_DATE__C,
    p.DENIED_REASON__C
FROM dbo.SF_PAYER__C p
    LEFT JOIN SHAREDSERVER.superbill_shared.dbo.sf_enrollment_status_hist i
        ON i.id = p.ID
    INNER JOIN dbo.SF_CASE c
        ON c.PAYER_ID__C = p.ID
    INNER JOIN dbo.SF_USER AS su
        ON c.OWNERID = su.ID
    INNER JOIN dbo.SF_ACCOUNT AS sa
        ON c.ACCOUNTID = sa.ID
WHERE p.LASTMODIFIEDDATE <>
(
    SELECT TOP 1
        c.lastmodifieddate
    FROM SHAREDSERVER.superbill_shared.dbo.sf_enrollment_status_hist c
    WHERE c.lastmodifieddate < p.LASTMODIFIEDDATE
          AND c.id = p.ID
)
      AND p.DELETE_FLAG = 'n'
      AND p.CREATEDDATE > GETDATE() - 90
      AND c.STATUS NOT IN ( 'Cancelled', 'Closed' )
      AND c.DELETE_FLAG = 'N'
      AND su.DELETE_FLAG = 'N'
      AND sa.DELETE_FLAG = 'N';





--SELECT a.id , COUNT(*)FROM dbo.SF_PAYER__C a GROUP BY a.ID HAVING COUNT(*)>1

--SELECT TOP 10 DENIED_REASON__C,* FROM dbo.SF_PAYER__C
