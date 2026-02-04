-- Stale incomplete jobs (started more than 7 days ago, not finished)
-- Identifies jobs that may be stuck or abandoned and need attention
SELECT
  label AS [Job Type],
  datetime(timeStarted, 'unixepoch') AS [Time Started],
  CASE
    WHEN timeCompleted IS NOT NULL THEN datetime(timeCompleted, 'unixepoch')
    ELSE 'Still Running?'
  END AS [Time Completed],
  CAST((strftime('%s', 'now') - timeStarted) / 86400 AS TEXT) || ' days ago' AS [Age],
  CASE
    WHEN INSTR(driveList, '(') > 0 AND INSTR(driveList, ')') > INSTR(driveList, '(')
      THEN SUBSTR(driveList, INSTR(driveList, '(') + 1, INSTR(driveList, ')') - INSTR(driveList, '(') - 1)
    ELSE IFNULL(driveList, 'No drive info')
  END AS [Status Detail],
  CASE
    WHEN CAST(numKbytes AS FLOAT) / 1024 / 1024 >= 1 THEN
      printf('%.2f GB', ROUND(CAST(numKbytes AS FLOAT) / 1024 / 1024, 2))
    ELSE
      printf('%.2f MB', ROUND(CAST(numKbytes AS FLOAT) / 1024, 2))
  END AS [Size],
  numFiles AS [File Count],
  client AS [Client],
  planName AS [Plan Name]
FROM Job
WHERE class LIKE '%ArchiveJobResource%'
  AND driveList NOT LIKE '%Finished%'
  AND timeStarted < strftime('%s', 'now', '-7 days')
ORDER BY timeStarted ASC;
