-- Yearly job status counts with size breakdown by outcome
-- Fixed: Failed and NULL sizes were in KB while others in TB (now all TB)
-- Fixed: NULL category now also excludes FAILED! jobs for cleaner categorization
SELECT
  label AS [Job Type],
  STRFTIME('%Y', datetime(timeStarted, 'unixepoch')) AS [Year],
  COUNT(*) AS [Total Jobs],
  SUM(CASE WHEN driveList LIKE '%Finished%' THEN 1 ELSE 0 END) AS [Finished],
  SUM(CASE WHEN driveList LIKE '%INCOMPLETE!%' THEN 1 ELSE 0 END) AS [Incomplete],
  SUM(CASE WHEN driveList LIKE '%FAILED!%' THEN 1 ELSE 0 END) AS [Failed],
  SUM(CASE WHEN (driveList NOT LIKE '%Finished%' AND driveList NOT LIKE '%INCOMPLETE!%' AND driveList NOT LIKE '%FAILED!%') OR driveList IS NULL THEN 1 ELSE 0 END) AS [Other],
  printf('%.2f', ROUND(SUM(CASE WHEN driveList LIKE '%Finished%' THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 2)) AS [Finished (TB)],
  printf('%.2f', ROUND(SUM(CASE WHEN driveList LIKE '%INCOMPLETE!%' THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 2)) AS [Incomplete (TB)],
  printf('%.2f', ROUND(SUM(CASE WHEN driveList LIKE '%Finished%' OR driveList LIKE '%INCOMPLETE!%' THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 2)) AS [Finished + Incomplete (TB)],
  printf('%.4f', ROUND(SUM(CASE WHEN driveList LIKE '%FAILED!%' THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 4)) AS [Failed (TB)],
  printf('%.4f', ROUND(SUM(CASE WHEN (driveList NOT LIKE '%Finished%' AND driveList NOT LIKE '%INCOMPLETE!%' AND driveList NOT LIKE '%FAILED!%') OR driveList IS NULL THEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 ELSE 0 END), 4)) AS [Other (TB)]
FROM Job
WHERE class LIKE '%ArchiveJobResource%'
GROUP BY [Year]
ORDER BY [Year] DESC;
