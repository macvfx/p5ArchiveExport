SELECT
	label AS [Job Type],
	STRFTIME('%Y', datetime(timeStarted, 'unixepoch')) AS [Year],
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '01' THEN 1 ELSE 0 END) AS Jan,
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '02' THEN 1 ELSE 0 END) AS Feb,
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '03' THEN 1 ELSE 0 END) AS Mar,
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '04' THEN 1 ELSE 0 END) AS Apr,
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '05' THEN 1 ELSE 0 END) AS May,
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '06' THEN 1 ELSE 0 END) AS Jun,
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '07' THEN 1 ELSE 0 END) AS Jul,
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '08' THEN 1 ELSE 0 END) AS Aug,
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '09' THEN 1 ELSE 0 END) AS Sep,
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '10' THEN 1 ELSE 0 END) AS Oct,
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '11' THEN 1 ELSE 0 END) AS Nov,
	SUM(CASE WHEN STRFTIME('%m', datetime(timeStarted, 'unixepoch')) = '12' THEN 1 ELSE 0 END) AS Dec
FROM Job
WHERE class LIKE '%ArchiveJobResource%'
GROUP BY [Year]
ORDER BY [Year] DESC;