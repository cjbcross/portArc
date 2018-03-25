
CREATE TABLE public.tasks
(
  choice character varying(100),
  folder character varying(400),
  task_id BIGSERIAL PRIMARY KEY,
  version integer,
  selected_time_stamp integer,
  completed_time_stamp integer,
  removed_time_stamp integer,
  username character varying(40)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.tasks
  OWNER TO postgres;