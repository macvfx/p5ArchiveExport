-- Total archive size in KB, GB, and TB
-- Fixed: SUM(printf()) was summing formatted strings, not numbers.
-- Now sums numeric values first, then formats the result.
SELECT
  SUM(numKbytes) AS [Total Size (KB)],
  printf('%.2f', ROUND(SUM(CAST(numKbytes AS FLOAT)) / 1024 / 1024, 2)) AS [Total Size (GB)],
  printf('%.2f', ROUND(SUM(CAST(numKbytes AS FLOAT)) / 1024 / 1024 / 1024, 2)) AS [Total Size (TB)]
FROM Job
WHERE CAST(numKbytes AS FLOAT) > 1024 * 1024
  AND class LIKE '%ArchiveJobResource%';
