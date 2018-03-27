UPDATE folders
SET file_count=sub.file_count
FROM (
SELECT COUNT(file_metadata.filename) as file_count, folders.folder as folder
FROM file_metadata, folders 
WHERE file_metadata.file_href LIKE folders.folder || '%' 
GROUP BY folders.folder
) AS sub
WHERE folders.folder=sub.folder;


