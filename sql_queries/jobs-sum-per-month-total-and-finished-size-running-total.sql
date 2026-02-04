SELECT 
	STRFTIME('%Y-%m', datetime(timeStarted, 'unixepoch')) AS [Month],
	COUNT(*) AS [Total Jobs],
	SUM(CASE WHEN driveList LIKE '%Finished%' THEN 1 ELSE 0 END) AS [Finished Jobs],
	printf('%.2f TB', ROUND(SUM(CASE WHEN driveList LIKE '%Finished%' THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 2)) AS [Finished]
FROM Job
WHERE class LIKE '%ArchiveJobResource%'
GROUP BY [Month]
ORDER BY [Month] DESC;
