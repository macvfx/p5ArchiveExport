SELECT
	label AS [Job Type],
	STRFTIME('%Y', datetime(timeStarted, 'unixepoch')) AS [Year],
	COUNT(*) AS [Total Jobs],
	SUM(CASE WHEN driveList LIKE '%Finished%' THEN 1 ELSE 0 END) AS [Finished],
	SUM(CASE WHEN driveList LIKE '%INCOMPLETE!%' THEN 1 ELSE 0 END) AS [Incomplete],
	SUM(CASE WHEN driveList LIKE '%FAILED!%' THEN 1 ELSE 0 END) AS [Failed],
	SUM(CASE WHEN (driveList NOT LIKE '%Finished%' AND driveList NOT LIKE '%INCOMPLETE!%') OR driveList IS NULL THEN 1 ELSE 0 END) AS [NULL]
FROM Job
WHERE class LIKE '%ArchiveJobResource%'
GROUP BY [Year]
ORDER BY [Year] DESC;
