DECLARE @tableHTML NVARCHAR(MAX)

SET @tableHTML =
    N'<H1>Provider Deactivations - ' +CONVERT(VARCHAR(100), DATEADD(DAY,-14, GETDATE() ),1) + ' - ' +Convert(varchar(100), GETDATE(),1 ) +'</H1>' +
    N'<table border="1">' +
    N'<tr>
    <th>Deactivation Date</th>
    <th>Customer ID</th>
    <th>Customer Name</th>
    <th>Practice ID</th>
    <th>Doctor ID</th>
    <th>Deactivation From</th>
    <th>Reason Picked</th>
    <th>Question Asked</th>
    <th>Response</th>
    </tr>' +
    CAST ( (        
       SELECT
			td =  CONVERT(VARCHAR(100),dh.CreatedDate,100),    '', 
			td = c.CustomerID,    '',
			td = c.CompanyName,    '',
			td = dh.PracticeID,    '',
			td = dh.DoctorID,    '',
			td = dt.TopicType,    '',
			td = dt.ReasonOption, '',
			td = dt.Question,    '',
			td = dr.QuestionResponse,    ''
FROM
dbo.DoctorHistory dh (NOLOCK)
INNER JOIN dbo.DeactivationResponse dr (NOLOCK) ON dh.ResponseID = dr.ResponseID
INNER JOIN dbo.DeactivationTopic dt (NOLOCK) ON dr.TopicID = dt.TopicID
INNER JOIN dbo.customer c (NOLOCK) ON dh.CustomerID = c.CustomerID
WHERE dh.CreatedDate > DATEADD(DAY,-14, GETDATE() )
ORDER BY dh.CreatedDate ASC
 FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' ;
    

EXEC msdb.dbo.sp_send_dbmail 
@recipients='james@kareo.com',
@subject = 'Recent Provider Deactivations',
@body=@tableHTML,
@profile_name = 'Default Profile',
@body_format = 'HTML' ;
