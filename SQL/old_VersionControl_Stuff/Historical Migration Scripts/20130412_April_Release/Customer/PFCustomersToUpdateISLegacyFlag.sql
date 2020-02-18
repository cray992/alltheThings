

UPDATE P
SET IsLegacyEHRPartner=0
FROM Practice P
INNER JOIN dbo.PracticeIntegration AS PI WITH (NOLOCK) ON P.PracticeID = PI.PracticeID
WHERE p.IsLegacyEHRPartner=1 AND Pi.PracticeFusionStatus='C'
AND p.Active=1



