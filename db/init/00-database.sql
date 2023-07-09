\connect streaming-overlay;

SET client_encoding = 'LATIN1';

CREATE OR REPLACE FUNCTION trigger_updated_at()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TYPE public.task_status AS ENUM (
  'TODO',
  'BLOCKED', -- Intent: when blocked by a subtask or prereq
  'IN_PROGRESS',
  'DONE'
);

CREATE TABLE IF NOT EXISTS public.task (
	id serial PRIMARY KEY,
  to_do text NOT NULL,
  status public.task_status NOT NULL DEFAULT 'TODO',
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

CREATE FUNCTION public.task_has_subtasks(task public.task)
RETURNS TEXT AS $$
  SELECT
    CASE
      WHEN EXISTS (
        SELECT 1
        FROM public.relation_subtask
        WHERE task_id = task.id
      ) THEN 'true'
      ELSE 'false'
    END
$$ LANGUAGE SQL STABLE;

CREATE FUNCTION public.task_is_subtask(task public.task)
RETURNS TEXT AS $$
  SELECT
    CASE
      WHEN EXISTS (
        SELECT 1
        FROM public.relation_subtask
        WHERE subtask_task_id = task.id
      ) THEN 'true'
      ELSE 'false'
    END
$$ LANGUAGE SQL STABLE;

CREATE FUNCTION public.task_has_prereqs(task public.task)
RETURNS TEXT AS $$
  SELECT
    CASE
      WHEN EXISTS (
        SELECT 1
        FROM public.relation_prerequisite
        WHERE task_id = task.id
      ) THEN 'true'
      ELSE 'false'
    END
$$ LANGUAGE SQL STABLE;

CREATE FUNCTION public.task_is_prereq(task public.task)
RETURNS TEXT AS $$
  SELECT
    CASE
      WHEN EXISTS (
        SELECT 1
        FROM public.relation_prerequisite
        WHERE prerequisite_task_id = task.id
      ) THEN 'true'
      ELSE 'false'
    END
$$ LANGUAGE SQL STABLE;