-- Yearly job status counts AND sizes to rule out failed/null job impact
-- Fixed: duplicate column names [Finished], [Incomplete], [Failed], [NULL]
-- Fixed: inconsistent units (was KB for failed/null, TB for others)
-- Fixed: filename typo "rull-out" -> "rule-out"
SELECT
  label AS [Job Type],
  STRFTIME('%Y', datetime(timeStarted, 'unixepoch')) AS [Year],
  COUNT(*) AS [Total Jobs],
  SUM(CASE WHEN driveList LIKE '%Finished%' THEN 1 ELSE 0 END) AS [Finished Count],
  SUM(CASE WHEN driveList LIKE '%INCOMPLETE!%' THEN 1 ELSE 0 END) AS [Incomplete Count],
  SUM(CASE WHEN driveList LIKE '%FAILED!%' THEN 1 ELSE 0 END) AS [Failed Count],
  SUM(CASE WHEN (driveList NOT LIKE '%Finished%' AND driveList NOT LIKE '%INCOMPLETE!%' AND driveList NOT LIKE '%FAILED!%') OR driveList IS NULL THEN 1 ELSE 0 END) AS [Other Count],
  printf('%.2f TB', ROUND(SUM(CASE WHEN driveList LIKE '%Finished%' THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 2)) AS [Finished Size (TB)],
  printf('%.2f TB', ROUND(SUM(CASE WHEN driveList LIKE '%INCOMPLETE!%' THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 2)) AS [Incomplete Size (TB)],
  printf('%.2f TB', ROUND(SUM(CASE WHEN driveList LIKE '%FAILED!%' THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 4)) AS [Failed Size (TB)],
  printf('%.2f TB', ROUND(SUM(CASE WHEN (driveList NOT LIKE '%Finished%' AND driveList NOT LIKE '%INCOMPLETE!%' AND driveList NOT LIKE '%FAILED!%') OR driveList IS NULL THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 4)) AS [Other Size (TB)]
FROM Job
WHERE class LIKE '%ArchiveJobResource%'
GROUP BY [Year]
ORDER BY [Year] DESC;
