-- Quarterly archive summary
-- Higher-level view than monthly, good for management reporting
-- Column convention: a parenthesised unit -- [Total Size (TB)] -- is a formatted
-- display string ("33.80 TB"). A bare unit suffix -- [Total TB] -- is a plain number
-- for charting. Display columns keep their existing names AND positions; numeric
-- columns are appended at the end, so importers that map by header name (P5 Archive
-- Browser, Project Folder Tracker, p5chart.py) are unaffected.
SELECT
  STRFTIME('%Y', datetime(timeStarted, 'unixepoch')) || '-Q' ||
    CASE
      WHEN CAST(STRFTIME('%m', datetime(timeStarted, 'unixepoch')) AS INTEGER) BETWEEN 1 AND 3 THEN '1'
      WHEN CAST(STRFTIME('%m', datetime(timeStarted, 'unixepoch')) AS INTEGER) BETWEEN 4 AND 6 THEN '2'
      WHEN CAST(STRFTIME('%m', datetime(timeStarted, 'unixepoch')) AS INTEGER) BETWEEN 7 AND 9 THEN '3'
      ELSE '4'
    END AS [Quarter],
  COUNT(*) AS [Total Jobs],
  SUM(CASE WHEN driveList LIKE '%Finished%' THEN 1 ELSE 0 END) AS [Finished],
  SUM(CASE WHEN driveList LIKE '%INCOMPLETE!%' OR driveList LIKE '%FAILED!%' THEN 1 ELSE 0 END) AS [Failed/Incomplete],
  printf('%.2f TB', ROUND(SUM(CAST(numKbytes AS FLOAT)) / 1024 / 1024 / 1024, 2)) AS [Total Size (TB)],
  printf('%.2f TB', ROUND(SUM(CASE WHEN driveList LIKE '%Finished%' THEN CAST(numKbytes AS FLOAT) ELSE 0 END) / 1024 / 1024 / 1024, 2)) AS [Finished Size (TB)],
  SUM(numFiles) AS [Total Files],
  COUNT(DISTINCT client) AS [Unique Clients],
  printf('%.1f%%', ROUND(100.0 * SUM(CASE WHEN driveList LIKE '%Finished%' THEN 1 ELSE 0 END) / COUNT(*), 1)) AS [Success Rate],
  ROUND(SUM(CAST(numKbytes AS FLOAT)) / 1024 / 1024 / 1024, 6) AS [Total TB],
  ROUND(SUM(CASE WHEN driveList LIKE '%Finished%' THEN CAST(numKbytes AS FLOAT) ELSE 0 END)
        / 1024 / 1024 / 1024, 6) AS [Finished TB],
  ROUND(100.0 * SUM(CASE WHEN driveList LIKE '%Finished%' THEN 1 ELSE 0 END) / COUNT(*), 2) AS [Success Rate Pct]
FROM Job
WHERE class LIKE '%ArchiveJobResource%'
GROUP BY [Quarter]
ORDER BY [Quarter] DESC;
