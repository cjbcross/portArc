﻿UPDATE folders
SET pdf_count=sub.pdf_count
FROM (
SELECT COUNT(file_metadata.filename) as pdf_count, folders.folder as folder
FROM file_metadata, folders 
WHERE file_metadata.file_href LIKE folders.folder || '%'
AND file_metadata.file_type = 'pdf'
GROUP BY folders.folder 
) AS sub
WHERE folders.folder=sub.folder;






