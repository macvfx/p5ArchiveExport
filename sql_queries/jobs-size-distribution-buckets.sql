-- Archive job size distribution in buckets
-- Shows how jobs are distributed across size ranges
-- Column convention: a parenthesised unit -- [Total Size (TB)] -- is a formatted
-- display string ("33.80 TB"). A bare unit suffix -- [Total TB] -- is a plain number
-- for charting. Display columns keep their existing names AND positions; numeric
-- columns are appended at the end, so importers that map by header name (P5 Archive
-- Browser, Project Folder Tracker, p5chart.py) are unaffected.
SELECT
  CASE
    WHEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 >= 1 THEN '5) 1 TB+'
    WHEN CAST(numKbytes AS FLOAT) / 1024 / 1024 >= 100 THEN '4) 100 GB - 1 TB'
    WHEN CAST(numKbytes AS FLOAT) / 1024 / 1024 >= 10 THEN '3) 10 GB - 100 GB'
    WHEN CAST(numKbytes AS FLOAT) / 1024 / 1024 >= 1 THEN '2) 1 GB - 10 GB'
    ELSE '1) Under 1 GB'
  END AS [Size Range],
  COUNT(*) AS [Job Count],
  printf('%.2f TB', ROUND(SUM(CAST(numKbytes AS FLOAT)) / 1024 / 1024 / 1024, 2)) AS [Total Size],
  printf('%.1f%%', ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM Job WHERE class LIKE '%ArchiveJobResource%'), 1)) AS [% of Jobs],
  printf('%.1f%%', ROUND(100.0 * SUM(CAST(numKbytes AS FLOAT)) / (SELECT SUM(CAST(numKbytes AS FLOAT)) FROM Job WHERE class LIKE '%ArchiveJobResource%'), 1)) AS [% of Storage],
  printf('%.2f GB', ROUND(AVG(CAST(numKbytes AS FLOAT)) / 1024 / 1024, 2)) AS [Avg Size],
  ROUND(SUM(CAST(numKbytes AS FLOAT)) / 1024 / 1024 / 1024, 6) AS [Total TB],
  ROUND(AVG(CAST(numKbytes AS FLOAT)) / 1024 / 1024 / 1024, 6) AS [Avg TB],
  ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM Job WHERE class LIKE '%ArchiveJobResource%'), 2) AS [Jobs Pct],
  ROUND(100.0 * SUM(CAST(numKbytes AS FLOAT)) / (SELECT SUM(CAST(numKbytes AS FLOAT)) FROM Job WHERE class LIKE '%ArchiveJobResource%'), 2) AS [Storage Pct]
FROM Job
WHERE class LIKE '%ArchiveJobResource%'
GROUP BY [Size Range]
ORDER BY [Size Range];
