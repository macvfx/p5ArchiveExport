-- Top 20 longest-running archive jobs by duration
-- Identifies slow jobs that may indicate tape or network issues
SELECT
  label AS [Job Type],
  datetime(timeStarted, 'unixepoch') AS [Time Started],
  datetime(timeCompleted, 'unixepoch') AS [Time Completed],
  CASE
    WHEN timeCompleted IS NULL OR timeStarted IS NULL OR timeCompleted <= timeStarted THEN 'N/A'
    WHEN (timeCompleted - timeStarted) / 86400 > 0 THEN
      CAST((timeCompleted - timeStarted) / 86400 AS TEXT) || ' day' ||
      CASE WHEN (timeCompleted - timeStarted) / 86400 = 1 THEN ' ' ELSE 's ' END ||
      strftime('%H:%M:%S', (timeCompleted - timeStarted) % 86400, 'unixepoch')
    ELSE
      strftime('%H:%M:%S', timeCompleted - timeStarted, 'unixepoch')
  END AS [Duration],
  (timeCompleted - timeStarted) AS [Duration (Seconds)],
  CASE
    WHEN driveList LIKE '%Finished%' THEN 'Finished'
    WHEN driveList LIKE '%INCOMPLETE!%' THEN 'INCOMPLETE!'
    WHEN driveList LIKE '%FAILED!%' THEN 'FAILED!'
    ELSE 'Other'
  END AS [Job Status],
  CASE
    WHEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 >= 1 THEN
      printf('%.2f TB', ROUND(CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024, 2))
    WHEN CAST(numKbytes AS FLOAT) / 1024 / 1024 >= 1 THEN
      printf('%.2f GB', ROUND(CAST(numKbytes AS FLOAT) / 1024 / 1024, 2))
    ELSE
      printf('%.2f MB', ROUND(CAST(numKbytes AS FLOAT) / 1024, 2))
  END AS [Size],
  -- Throughput in MB/s (only for completed jobs with nonzero duration)
  CASE
    WHEN timeCompleted > timeStarted AND (timeCompleted - timeStarted) > 0 THEN
      printf('%.2f MB/s', ROUND(CAST(numKbytes AS FLOAT) / 1024 / (timeCompleted - timeStarted), 2))
    ELSE 'N/A'
  END AS [Throughput],
  client AS [Client]
FROM Job
WHERE class LIKE '%ArchiveJobResource%'
  AND timeCompleted IS NOT NULL
  AND timeStarted IS NOT NULL
  AND timeCompleted > timeStarted
ORDER BY (timeCompleted - timeStarted) DESC
LIMIT 20;
