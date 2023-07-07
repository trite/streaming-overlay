\connect streaming-overlay;

SET client_encoding = 'LATIN1';

CREATE OR REPLACE FUNCTION trigger_updated_at()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS public.task (
	id serial PRIMARY KEY,
  to_do text NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TRIGGER task_trigger_updated_at
   BEFORE UPDATE ON public.task
   FOR EACH ROW
   EXECUTE PROCEDURE trigger_updated_at();

CREATE TABLE IF NOT EXISTS public.relation_subtask (
   id SERIAL PRIMARY KEY,
   task_id INT NOT NULL REFERENCES public.task(id),
   subtask_task_id INT NOT NULL REFERENCES public.task(id),
   created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
   updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER relation_subtask_trigger_updated_at
   BEFORE UPDATE ON public.relation_subtask
   FOR EACH ROW
   EXECUTE PROCEDURE trigger_updated_at();

COMMENT ON CONSTRAINT relation_subtask_subtask_task_id_fkey
  ON public.relation_subtask IS
  E'@foreignFieldName subtaskOf';

COMMENT ON CONSTRAINT relation_subtask_task_id_fkey
  ON public.relation_subtask IS
  E'@foreignFieldName subtasks';

CREATE TABLE IF NOT EXISTS public.relation_prerequisite (
   id SERIAL PRIMARY KEY,
   task_id INT NOT NULL REFERENCES public.task(id),
   prerequisite_task_id INT NOT NULL REFERENCES public.task(id),
   created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
   updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER relation_prerequisite_trigger_updated_at
   BEFORE UPDATE ON public.relation_prerequisite
   FOR EACH ROW
   EXECUTE PROCEDURE trigger_updated_at();

COMMENT ON CONSTRAINT relation_prerequisite_prerequisite_task_id_fkey
  ON public.relation_prerequisite IS
  E'@foreignFieldName prerequisiteOf';

COMMENT ON CONSTRAINT relation_prerequisite_task_id_fkey
  ON public.relation_prerequisite IS
  E'@foreignFieldName prerequisites';