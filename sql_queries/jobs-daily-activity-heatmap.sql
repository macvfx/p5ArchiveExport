-- Daily archive activity heatmap data
-- Shows job counts by day-of-week and hour-of-day
-- Useful for identifying peak archive times and scheduling
SELECT
  CASE CAST(strftime('%w', datetime(timeStarted, 'unixepoch')) AS INTEGER)
    WHEN 0 THEN 'Sunday'
    WHEN 1 THEN 'Monday'
    WHEN 2 THEN 'Tuesday'
    WHEN 3 THEN 'Wednesday'
    WHEN 4 THEN 'Thursday'
    WHEN 5 THEN 'Friday'
    WHEN 6 THEN 'Saturday'
  END AS [Day of Week],
  CAST(strftime('%w', datetime(timeStarted, 'unixepoch')) AS INTEGER) AS [Day Number],
  strftime('%H', datetime(timeStarted, 'unixepoch')) || ':00' AS [Hour],
  COUNT(*) AS [Job Count],
  printf('%.2f GB', ROUND(SUM(CAST(numKbytes AS FLOAT)) / 1024 / 1024, 2)) AS [Total Size]
FROM Job
WHERE class LIKE '%ArchiveJobResource%'
GROUP BY [Day Number], [Hour]
ORDER BY [Day Number], [Hour];
