SELECT 
  label, 
  printf('%.2f TB', ROUND(SUM(numKbytes / 1024.0 / 1024.0 / 1024.0), 2)) AS [Total Size]
FROM Job
WHERE class LIKE '%ArchiveJobResource%'
GROUP BY label;


