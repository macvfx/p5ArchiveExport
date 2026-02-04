-- Archive job throughput analysis (MB/s)
-- Helps identify performance trends and bottlenecks
-- Only includes finished jobs with valid duration
SELECT
  label AS [Job Type],
  datetime(timeStarted, 'unixepoch') AS [Time Started],
  CASE
    WHEN (timeCompleted - timeStarted) / 86400 > 0 THEN
      CAST((timeCompleted - timeStarted) / 86400 AS TEXT) || 'd ' ||
      strftime('%H:%M:%S', (timeCompleted - timeStarted) % 86400, 'unixepoch')
    ELSE
      strftime('%H:%M:%S', timeCompleted - timeStarted, 'unixepoch')
  END AS [Duration],
  CASE
    WHEN CAST(numKbytes AS FLOAT) / 1024 / 1024 >= 1 THEN
      printf('%.2f GB', ROUND(CAST(numKbytes AS FLOAT) / 1024 / 1024, 2))
    ELSE
      printf('%.2f MB', ROUND(CAST(numKbytes AS FLOAT) / 1024, 2))
  END AS [Size],
  printf('%.2f', ROUND(CAST(numKbytes AS FLOAT) / 1024 / (timeCompleted - timeStarted), 2)) AS [Throughput (MB/s)],
  numFiles AS [File Count],
  CASE
    WHEN numFiles > 0 AND (timeCompleted - timeStarted) > 0 THEN
      printf('%.1f', ROUND(CAST(numFiles AS FLOAT) / (timeCompleted - timeStarted) * 60, 1))
    ELSE 'N/A'
  END AS [Files per Minute],
  client AS [Client]
FROM Job
WHERE class LIKE '%ArchiveJobResource%'
  AND driveList LIKE '%Finished%'
  AND timeCompleted > timeStarted
  AND (timeCompleted - timeStarted) > 0
ORDER BY CAST(numKbytes AS FLOAT) / (timeCompleted - timeStarted) DESC;
