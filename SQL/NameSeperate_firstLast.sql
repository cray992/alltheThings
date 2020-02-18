-- Separate First and Last name from same column—

SUBSTRING(iep.patient,1,CHARINDEX(',',iep.patient)-1) AS lastname ,
SUBSTRING(iep.patient,CHARINDEX(',',iep.patient)+1,8000)AS firstname ,
