CREATE TABLE folders
(
  application character varying(25),
  folder character varying(1000),
  file_count integer,
  xpt_count integer,
  xml_count integer,
  pdf_count integer,
  folder_id bigserial NOT NULL,
  CONSTRAINT folder_id_key PRIMARY KEY (folder_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE folders
  OWNER TO postgres;
 
-- Index: application_index
-- DROP INDEX application_index;
 
CREATE INDEX application_index
  ON folders
  USING btree
  (application COLLATE pg_catalog."default");
 
-- Index: folder_index
-- DROP INDEX folder_index;
 
CREATE INDEX folder_index
  ON folders
  USING btree
  (folder COLLATE pg_catalog."default");

insert into folders (folder,application) (select distinct regexp_replace(file_href,filename,''),application FROM file_metadata);
