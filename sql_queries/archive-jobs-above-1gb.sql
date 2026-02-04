-- Extract the first LTO tape label (L1-L9) from volumeList for clarity using a CTE
WITH JobWithTape AS (
  SELECT *,
	IFNULL(
	  SUBSTR(
		volumeList,
		COALESCE(
		  NULLIF(INSTR(volumeList, 'L1'), 0),
		  NULLIF(INSTR(volumeList, 'L2'), 0),
		  NULLIF(INSTR(volumeList, 'L3'), 0),
		  NULLIF(INSTR(volumeList, 'L4'), 0),
		  NULLIF(INSTR(volumeList, 'L5'), 0),
		  NULLIF(INSTR(volumeList, 'L6'), 0),
		  NULLIF(INSTR(volumeList, 'L7'), 0),
		  NULLIF(INSTR(volumeList, 'L8'), 0),
		  NULLIF(INSTR(volumeList, 'L9'), 0)
		) - 6, 8
	  ),
	  'None'
	) AS LTO_Tape_Extracted
  FROM Job
)
-- CTE to clean up savedFiles for readability
, CleanedJobWithTape AS (
  SELECT *,
	-- Stepwise transformation for [New Saved Files]:
	-- 1. Remove '{' and '}'.
	-- 2. Replace ' ' with '$#'.
	-- 3. Replace '$#/' with '$#//'.
	-- 4. Replace '$#/' with CHAR(10) (newline).
	-- 5. Replace '$#' with ' '.
	CASE
	  WHEN savedFiles IS NULL OR savedFiles = '' THEN '[empty]'
	  ELSE REPLACE(
			 REPLACE(
			   REPLACE(
				 REPLACE(
				   REPLACE(
					 REPLACE(savedFiles, '{', ''),
				   '}', ''),
				 ' ', '$#'),
			   '$#/', '$#//'),
			 '$#/', CHAR(10)),
		   '$#', ' ')
	END AS [New Saved Files]
  FROM JobWithTape
)
SELECT 
  label AS [Job Type],
  datetime(timeStarted, 'unixepoch') AS [Time Started],   
  datetime(timeCompleted, 'unixepoch') AS [Time Completed],
  -- Duration in days
  CASE
	WHEN strftime('%j', timeCompleted - timeStarted, 'unixepoch') = '001' THEN '1 day'
	WHEN strftime('%j', timeCompleted - timeStarted, 'unixepoch') = '000' THEN ''
	ELSE ltrim(strftime('%j', timeCompleted - timeStarted, 'unixepoch'), '0') || ' day' || 
	  CASE WHEN ltrim(strftime('%j', timeCompleted - timeStarted, 'unixepoch'), '0') = '1' THEN '' ELSE 's' END
  END AS [Duration],
  -- Extracted status message
  CASE
	WHEN INSTR(driveList, '(') > 0 AND INSTR(driveList, ')') > INSTR(driveList, '(')
	  THEN SUBSTR(driveList, INSTR(driveList, '(') + 1, INSTR(driveList, ')') - INSTR(driveList, '(') - 1)
	ELSE NULL
  END AS [Status Message],
  LTO_Tape_Extracted AS [LTO Tape],
  CASE 
	WHEN driveList LIKE '%Finished%' THEN 'Finished'
	WHEN driveList LIKE '%INCOMPLETE!%' THEN 'INCOMPLETE!'
	ELSE 'TBD'
  END AS [Job Status],
  CASE
	WHEN CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024 >= 1 THEN
	  printf('%.2f TB', ROUND(CAST(numKbytes AS FLOAT) / 1024 / 1024 / 1024, 2))
	WHEN CAST(numKbytes AS FLOAT) / 1024 / 1024 >= 1 THEN
	  printf('%.2f GB', ROUND(CAST(numKbytes AS FLOAT) / 1024 / 1024, 2))
	WHEN CAST(numKbytes AS FLOAT) / 1024 >= 1 THEN
	  printf('%.2f MB', ROUND(CAST(numKbytes AS FLOAT) / 1024, 2))
	ELSE
	  printf('%.2f KB', CAST(numKbytes AS FLOAT))
  END AS [Size],
  [New Saved Files]
FROM CleanedJobWithTape
WHERE CAST(numKbytes AS FLOAT) > 1024 * 1024
  AND class LIKE '%ArchiveJobResource%'
ORDER BY [Time Started] DESC;