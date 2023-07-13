\connect streaming-overlay;

SET client_encoding = 'LATIN1';

CREATE OR REPLACE FUNCTION trigger_updated_at()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS public.markdown_chunk(
  id SERIAL PRIMARY KEY,
  chunk_name TEXT NOT NULL UNIQUE,
  markdown TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TRIGGER markdown_chunk_trigger_updated_at
   BEFORE UPDATE ON public.markdown_chunk
   FOR EACH ROW
   EXECUTE PROCEDURE trigger_updated_at();








-- CREATE TYPE public.task_status AS ENUM (
--   'TODO',
--   'BLOCKED', -- Intent: when blocked by a subtask or prereq
--   'IN_PROGRESS',
--   'DONE'
-- );

-- CREATE TABLE IF NOT EXISTS public.task (
-- 	id serial PRIMARY KEY,
--   to_do text NOT NULL,
--   status public.task_status NOT NULL DEFAULT 'TODO',
--   created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
--   updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
-- );

-- CREATE TRIGGER task_trigger_updated_at
--    BEFORE UPDATE ON public.task
--    FOR EACH ROW
--    EXECUTE PROCEDURE trigger_updated_at();

-- CREATE TABLE IF NOT EXISTS public.relation_subtask (
--    id SERIAL PRIMARY KEY,
--    task_id INT NOT NULL REFERENCES public.task(id),
--    subtask_task_id INT NOT NULL REFERENCES public.task(id),
--    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
--    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
-- );

-- CREATE TRIGGER relation_subtask_trigger_updated_at
--    BEFORE UPDATE ON public.relation_subtask
--    FOR EACH ROW
--    EXECUTE PROCEDURE trigger_updated_at();

-- COMMENT ON CONSTRAINT relation_subtask_subtask_task_id_fkey
--   ON public.relation_subtask IS
--   E'@foreignFieldName subtaskOf';

-- COMMENT ON CONSTRAINT relation_subtask_task_id_fkey
--   ON public.relation_subtask IS
--   E'@foreignFieldName subtasks';

-- CREATE TABLE IF NOT EXISTS public.relation_prereq (
--    id SERIAL PRIMARY KEY,
--    task_id INT NOT NULL REFERENCES public.task(id),
--    prereq_task_id INT NOT NULL REFERENCES public.task(id),
--    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
--    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
-- );

-- CREATE TRIGGER relation_prereq_trigger_updated_at
--    BEFORE UPDATE ON public.relation_prereq
--    FOR EACH ROW
--    EXECUTE PROCEDURE trigger_updated_at();

-- COMMENT ON CONSTRAINT relation_prereq_prereq_task_id_fkey
--   ON public.relation_prereq IS
--   E'@foreignFieldName prereqOf';

-- COMMENT ON CONSTRAINT relation_prereq_task_id_fkey
--   ON public.relation_prereq IS
--   E'@foreignFieldName prereqs';

-- CREATE FUNCTION public.task_has_subtasks(task public.task)
-- RETURNS TEXT AS $$
--   SELECT
--     CASE
--       WHEN EXISTS (
--         SELECT 1
--         FROM public.relation_subtask
--         WHERE task_id = task.id
--       ) THEN 'true'
--       ELSE 'false'
--     END
-- $$ LANGUAGE SQL STABLE;

-- CREATE FUNCTION public.task_is_subtask(task public.task)
-- RETURNS TEXT AS $$
--   SELECT
--     CASE
--       WHEN EXISTS (
--         SELECT 1
--         FROM public.relation_subtask
--         WHERE subtask_task_id = task.id
--       ) THEN 'true'
--       ELSE 'false'
--     END
-- $$ LANGUAGE SQL STABLE;

-- CREATE FUNCTION public.task_has_prereqs(task public.task)
-- RETURNS TEXT AS $$
--   SELECT
--     CASE
--       WHEN EXISTS (
--         SELECT 1
--         FROM public.relation_prereq
--         WHERE task_id = task.id
--       ) THEN 'true'
--       ELSE 'false'
--     END
-- $$ LANGUAGE SQL STABLE;

-- CREATE FUNCTION public.task_is_prereq(task public.task)
-- RETURNS TEXT AS $$
--   SELECT
--     CASE
--       WHEN EXISTS (
--         SELECT 1
--         FROM public.relation_prereq
--         WHERE prereq_task_id = task.id
--       ) THEN 'true'
--       ELSE 'false'
--     END
-- $$ LANGUAGE SQL STABLE;