UPDATE folders
SET xml_count=sub.xml_count
FROM (
SELECT COUNT(file_metadata.filename) as xml_count, folders.folder as folder
FROM file_metadata, folders 
WHERE file_metadata.file_href LIKE folders.folder || '%'
AND file_metadata.file_type = 'xml'
GROUP BY folders.folder 
) AS sub
WHERE folders.folder=sub.folder;






