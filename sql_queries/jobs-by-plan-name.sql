-- Archive jobs grouped by plan name
-- Shows which archive plans produce the most data
SELECT
  planName AS [Plan Name],
  COUNT(*) AS [Total Jobs],
  SUM(CASE WHEN driveList LIKE '%Finished%' THEN 1 ELSE 0 END) AS [Finished],
  SUM(CASE WHEN driveList LIKE '%INCOMPLETE!%' OR driveList LIKE '%FAILED!%' THEN 1 ELSE 0 END) AS [Failed/Incomplete],
  printf('%.2f TB', ROUND(SUM(CAST(numKbytes AS FLOAT)) / 1024 / 1024 / 1024, 2)) AS [Total Size],
  printf('%.2f TB', ROUND(SUM(CASE WHEN driveList LIKE '%Finished%' THEN CAST(numKbytes AS FLOAT) ELSE 0 END) / 1024 / 1024 / 1024, 2)) AS [Finished Size],
  SUM(numFiles) AS [Total Files],
  printf('%.2f GB', ROUND(AVG(CAST(numKbytes AS FLOAT)) / 1024 / 1024, 2)) AS [Avg Job Size],
  datetime(MIN(timeStarted), 'unixepoch') AS [First Job],
  datetime(MAX(timeStarted), 'unixepoch') AS [Last Job]
FROM Job
WHERE class LIKE '%ArchiveJobResource%'
  AND planName IS NOT NULL
  AND planName != ''
GROUP BY planName
ORDER BY SUM(CAST(numKbytes AS FLOAT)) DESC;
