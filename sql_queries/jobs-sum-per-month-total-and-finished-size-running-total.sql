
-- Column convention: a parenthesised unit -- [Total Size (TB)] -- is a formatted
-- display string ("33.80 TB"). A bare unit suffix -- [Total TB] -- is a plain number
-- for charting. Display columns keep their existing names AND positions; numeric
-- columns are appended at the end, so importers that map by header name are unaffected.
SELECT 
	STRFTIME('%Y-%m', datetime(timeStarted, 'unixepoch')) AS [Month],
	COUNT(*) AS [Total Jobs],
	SUM(CASE WHEN driveList LIKE '%Finished%' THEN 1 ELSE 0 END) AS [Finished Jobs],
	printf('%.2f TB', ROUND(SUM(CASE WHEN driveList LIKE '%Finished%' THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 2)) AS [Finished],
	ROUND(SUM(CASE WHEN driveList LIKE '%Finished%' THEN CAST(numKbytes AS FLOAT) ELSE 0 END) / 1024 / 1024 / 1024, 6) AS [Finished TB],
	ROUND(SUM(CAST(numKbytes AS FLOAT)) / 1024 / 1024 / 1024, 6) AS [Total TB]
FROM Job
WHERE class LIKE '%ArchiveJobResource%'
GROUP BY [Month]
ORDER BY [Month] DESC;
