SELECT 
	label AS [Job Type],
	STRFTIME('%Y', datetime(timeStarted, 'unixepoch')) AS [Year],
	
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '01' THEN 1 ELSE 0 END) AS [Jan | Total],
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '01' AND driveList LIKE '%Finished%' THEN 1 ELSE 0 END) AS [Jan | Finished],
	printf('%.2f TB', ROUND(SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '01' AND driveList LIKE '%Finished%' THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 2)) AS [Jan | Size],

	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '02' THEN 1 ELSE 0 END) AS [Feb | Total],
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '02' AND driveList LIKE '%Finished%' THEN 1 ELSE 0 END) AS [Feb | Finished],
	printf('%.2f TB', ROUND(SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '02' AND driveList LIKE '%Finished%' THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 2)) AS [Feb | Size],

	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '03' THEN 1 ELSE 0 END) AS [Mar | Total],
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '03' AND driveList LIKE '%Finished%' THEN 1 ELSE 0 END) AS [Mar | Finished],
	printf('%.2f TB', ROUND(SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '03' AND driveList LIKE '%Finished%' THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 2)) AS [Mar | Size],

	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '04' THEN 1 ELSE 0 END) AS [Apr | Total],
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '04' AND driveList LIKE '%Finished%' THEN 1 ELSE 0 END) AS [Apr | Finished],
	printf('%.2f TB', ROUND(SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '04' AND driveList LIKE '%Finished%' THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 2)) AS [Apr | Size],
	
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '05' THEN 1 ELSE 0 END) AS [May | Total],
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '05' AND driveList LIKE '%Finished%' THEN 1 ELSE 0 END) AS [May | Finished],
	printf('%.2f TB', ROUND(SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '05' AND driveList LIKE '%Finished%' THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 2)) AS [May | Size],

	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '06' THEN 1 ELSE 0 END) AS [Jun | Total],
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '06' AND driveList LIKE '%Finished%' THEN 1 ELSE 0 END) AS [Jun | Finished],
	printf('%.2f TB', ROUND(SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '06' AND driveList LIKE '%Finished%' THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 2)) AS [Jun | Size],

	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '07' THEN 1 ELSE 0 END) AS [Jul | Total],
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '07' AND driveList LIKE '%Finished%' THEN 1 ELSE 0 END) AS [Jul | Finished],
	printf('%.2f TB', ROUND(SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '07' AND driveList LIKE '%Finished%' THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 2)) AS [Jul | Size],

	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '08' THEN 1 ELSE 0 END) AS [Aug | Total],
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '08' AND driveList LIKE '%Finished%' THEN 1 ELSE 0 END) AS [Aug | Finished],
	printf('%.2f TB', ROUND(SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '08' AND driveList LIKE '%Finished%' THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 2)) AS [Aug | Size],

	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '09' THEN 1 ELSE 0 END) AS [Sep | Total],
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '09' AND driveList LIKE '%Finished%' THEN 1 ELSE 0 END) AS [Sep | Finished],
	printf('%.2f TB', ROUND(SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '09' AND driveList LIKE '%Finished%' THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 2)) AS [Sep | Size],
	
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '10' THEN 1 ELSE 0 END) AS [Oct | Total],
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '10' AND driveList LIKE '%Finished%' THEN 1 ELSE 0 END) AS [Oct | Finished],
	printf('%.2f TB', ROUND(SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '10' AND driveList LIKE '%Finished%' THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 2)) AS [Oct | Size],

	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '11' THEN 1 ELSE 0 END) AS [Nov | Total],
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '11' AND driveList LIKE '%Finished%' THEN 1 ELSE 0 END) AS [Nov | Finished],
	printf('%.2f TB', ROUND(SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '11' AND driveList LIKE '%Finished%' THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 2)) AS [Nov | Size],

	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '12' THEN 1 ELSE 0 END) AS [Dec | Total],
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '12' AND driveList LIKE '%Finished%' THEN 1 ELSE 0 END) AS [Dec | Finished],
	printf('%.2f TB', ROUND(SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '12' AND driveList LIKE '%Finished%' THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 2)) AS [Dec | Size]

FROM Job
-- WHERE label LIKE 'Archive'
WHERE class LIKE '%ArchiveJobResource%'
GROUP BY [Year], [Job Type]
ORDER BY [Year] DESC, [Job Type];


