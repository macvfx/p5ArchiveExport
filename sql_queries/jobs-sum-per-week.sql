-- Archive volume per week, all statuses, with idle weeks present as zeros.
--
-- The finest grain the other queries offer is monthly, and none of them emit a row
-- for a period with no activity. That matters more than it sounds: a chart built
-- from rows-that-exist draws a straight line across a gap, which reads as steady
-- throughput where there was actually a pause. The recursive CTE below builds a
-- continuous week spine from the first archive job to the last, so a week with no
-- jobs arrives as a real zero rather than as a missing row.
--
-- Weeks start Monday, and are keyed by the start date -- deliberately NOT by a week
-- number. strftime('%V') (true ISO week) needs SQLite 3.46+, newer than the system
-- SQLite on the macOS versions this app supports, and the obvious substitute
-- (day-of-year / 7) disagrees with ISO about half the time: it labels the week of
-- 2025-01-27 as W04 where ISO says W05. Emitting a week number that disagrees with
-- every other tool's would be worse than emitting none, so the start date is the key.
-- It sorts correctly, is unambiguous across year boundaries, and needs no convention
-- to interpret. Anything wanting an ISO label can derive one from the date.
--
-- Column convention: a parenthesised unit -- [Total Size (TB)] -- is a formatted
-- display string ("33.80 TB"). A bare unit suffix -- [Total TB] -- is a plain number
-- for charting.

WITH ArchiveJobs AS (
  SELECT
    -- Monday of the week this job started in. strftime('%w') is 0=Sunday..6=Saturday,
    -- so (w + 6) % 7 is how many days back Monday is.
    date(
      datetime(timeStarted, 'unixepoch'),
      '-' || ((CAST(strftime('%w', datetime(timeStarted, 'unixepoch')) AS INTEGER) + 6) % 7) || ' days'
    ) AS WeekStart,
    CAST(numKbytes AS FLOAT) AS SizeKB,
    COALESCE(numFiles, 0) AS Files,
    driveList
  FROM Job
  WHERE class LIKE '%ArchiveJobResource%'
    AND timeStarted IS NOT NULL
    AND timeStarted > 0
),
Bounds AS (
  SELECT MIN(WeekStart) AS FirstWeek, MAX(WeekStart) AS LastWeek FROM ArchiveJobs
),
WeekSpine AS (
  SELECT FirstWeek AS WeekStart FROM Bounds
  UNION ALL
  SELECT date(WeekStart, '+7 days')
  FROM WeekSpine
  WHERE WeekStart < (SELECT LastWeek FROM Bounds)
),
Weekly AS (
  SELECT
    WeekStart,
    COUNT(*) AS TotalJobs,
    SUM(CASE WHEN driveList LIKE '%Finished%' THEN 1 ELSE 0 END) AS Finished,
    SUM(CASE WHEN driveList LIKE '%INCOMPLETE!%' OR driveList LIKE '%FAILED!%' THEN 1 ELSE 0 END) AS FailedIncomplete,
    SUM(SizeKB) AS TotalKB,
    SUM(CASE WHEN driveList LIKE '%Finished%' THEN SizeKB ELSE 0 END) AS FinishedKB,
    SUM(Files) AS TotalFiles
  FROM ArchiveJobs
  GROUP BY WeekStart
)
SELECT
  s.WeekStart                                              AS [Week Starting],
  COALESCE(w.TotalJobs, 0)                                 AS [Total Jobs],
  COALESCE(w.Finished, 0)                                  AS [Finished],
  COALESCE(w.FailedIncomplete, 0)                          AS [Failed/Incomplete],
  printf('%.2f TB', ROUND(COALESCE(w.TotalKB, 0) / 1024 / 1024 / 1024, 2))
                                                           AS [Total Size (TB)],
  printf('%.2f TB', ROUND(COALESCE(w.FinishedKB, 0) / 1024 / 1024 / 1024, 2))
                                                           AS [Finished Size (TB)],
  COALESCE(w.TotalFiles, 0)                                AS [Total Files],
  CASE WHEN w.WeekStart IS NULL THEN 'yes' ELSE 'no' END   AS [Idle Week],
  ROUND(COALESCE(w.TotalKB, 0) / 1024 / 1024 / 1024, 6)    AS [Total TB],
  ROUND(COALESCE(w.FinishedKB, 0) / 1024 / 1024 / 1024, 6) AS [Finished TB]
FROM WeekSpine s
LEFT JOIN Weekly w ON w.WeekStart = s.WeekStart
ORDER BY s.WeekStart DESC;
