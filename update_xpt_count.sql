UPDATE folders
SET xpt_count=sub.xpt_count
FROM (
SELECT COUNT(file_metadata.filename) as xpt_count, folders.folder as folder
FROM file_metadata, folders 
WHERE file_metadata.file_href LIKE folders.folder || '%'
AND file_metadata.file_type = 'xpt'
GROUP BY folders.folder 
) AS sub
WHERE folders.folder=sub.folder;






