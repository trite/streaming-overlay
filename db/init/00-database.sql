\connect streaming-overlay;

SET client_encoding = 'LATIN1';

-- create function public.graphql_subscription() returns trigger as $$
-- declare
--   v_process_new bool = (TG_OP = 'INSERT' OR TG_OP = 'UPDATE');
--   v_process_old bool = (TG_OP = 'UPDATE' OR TG_OP = 'DELETE');
--   v_event text = TG_ARGV[0];
--   v_topic_template text = TG_ARGV[1];
--   v_attribute text = TG_ARGV[2];
--   v_record record;
--   v_sub text;
--   v_topic text;
--   v_i int = 0;
--   v_last_topic text;
-- begin
--   -- On UPDATE sometimes topic may be changed for NEW record,
--   -- so we need notify to both topics NEW and OLD.
--   for v_i in 0..1 loop
--     if (v_i = 0) and v_process_new is true then
--       v_record = new;
--     elsif (v_i = 1) and v_process_old is true then
--       v_record = old;
--     else
--       continue;
--     end if;
--      if v_attribute is not null then
--       execute 'select $1.' || quote_ident(v_attribute)
--         using v_record
--         into v_sub;
--     end if;
--     if v_sub is not null then
--       v_topic = replace(v_topic_template, '$1', v_sub);
--     else
--       v_topic = v_topic_template;
--     end if;
--     if v_topic is distinct from v_last_topic then
--       -- This if statement prevents us from triggering the same notification twice
--       v_last_topic = v_topic;
--       SELECT pg_notify(
--         v_topic,
--         json_build_object(
--           '__node__', json_build_array(
--             'allMarkdownChunks', -- IMPORTANT: this is not always exactly the table name; base64
--                     -- decode an existing nodeId to see what it should be.
--             1      -- The primary key (for multiple keys, list them all).
--           ) 
--         )
--       )
--       -- perform pg_notify(v_topic, json_build_object(
--       --   'event', v_event,
--       --   'subject', v_sub
--       -- )::text);
--     end if;
--   end loop;
--   return v_record;
-- end;
-- $$ language plpgsql volatile set search_path from current;

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

CREATE TABLE IF NOT EXISTS public.active_markdown_chunk(
  id SERIAL PRIMARY KEY,
  chunk_name TEXT NOT NULL REFERENCES public.markdown_chunk(chunk_name),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TRIGGER active_markdown_chunk_trigger_updated_at
   BEFORE UPDATE ON public.active_markdown_chunk
   FOR EACH ROW
   EXECUTE PROCEDURE trigger_updated_at();


-- CREATE TRIGGER subscribe_markdown_chunk
--   AFTER UPDATE ON public.markdown_chunk
--   FOR EACH ROW
--   EXECUTE PROCEDURE public.graphql_subscription(
--     'allMarkdownChunks', -- the "event" string, useful for the client to know what happened
--     'postgraphile:markdownChunk:$1' -- the "topic" the event will be published to, as a template
--     -- 'postgraphile:chunkChanged:$1', -- the "topic" the event will be published to, as a template
--     'id' -- If specified, `$1` above will be replaced with NEW.id or OLD.id from the trigger.
--   );

CREATE OR REPLACE FUNCTION public.notify_any_markdown_chunk_changed()
RETURNS TRIGGER AS $$
-- DECLARE
--   something_name_later TEXT;
BEGIN
  -- SELECT 1
  -- FROM public.active_markdown_chunk amc
  -- WHERE amc.chunk_name = NEW.chunk_name
  -- INTO something_name_later;

  PERFORM pg_notify(
    'postgraphile:currentMarkdownChunkChanged',
    json_build_object(
      '__node__',
      json_build_array(
        'allMarkdownChunks',
        NEW.id
      )
    )::TEXT
  );

  RETURN NEW;
END;

$$ LANGUAGE plpgsql;


CREATE TRIGGER subscribe_markdown_chunk
  AFTER INSERT OR UPDATE ON public.markdown_chunk
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_any_markdown_chunk_changed();

  -- SELECT 1
  -- FROM public.active_markdown_chunk amc
  -- WHERE amc.chunk_name = NEW.chunk_name
  -- INTO something_name_later;

  -- IF something_name_later IS NOT NULL THEN
  --   SELECT pg_notify(
  --     'postgraphile:currentMarkdownChunkChanged',
  --     json_build_object(
  --       '__node__',
  --       json_build_array(
  --         'markdownChunk'
  --       )
  --     )
  --   );
  -- END IF;




  
  
  
  
  -- public.graphql_subscription(
  --   'allMarkdownChunks', -- the "event" string, useful for the client to know what happened
  --   'postgraphile:markdownChunk:$1' -- the "topic" the event will be published to, as a template
  --   -- 'postgraphile:chunkChanged:$1', -- the "topic" the event will be published to, as a template
  --   'id' -- If specified, `$1` above will be replaced with NEW.id or OLD.id from the trigger.
  -- );

-- CREATE TRIGGER _500_gql_update_member
--   AFTER INSERT OR UPDATE OR DELETE ON app_public.organization_members
--   FOR EACH ROW
--   EXECUTE PROCEDURE app_public.graphql_subscription('organizationsChanged', 'graphql:user:$1', 'member_id');




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