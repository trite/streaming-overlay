\connect streaming-overlay;

INSERT INTO public.markdown_chunk(chunk_name, markdown)
VALUES
  ('stream-overlay', '# Stream Overlay

  ## What is this?

  This is a web app that allows you to display markdown on your stream.'),
  ('organization-app', '# Organization App

  ## What is this?

  The world clearly needs more todo/calendar/notes apps, so here''s another!');


INSERT INTO public.active_markdown_chunk(chunk_name)
VALUES
  ('stream-overlay');




-- INSERT INTO public.task(to_do)
-- VALUES
--   ('Convert app to TypeScript/Postgres/GraphQL'),
--   ('Create `Control` and `Display` pages'),
--   ('Create `Control` page'),
--   ('Create `Display` page'),
--   ('Wire up subscriptions to `Display` page');

-- INSERT INTO public.relation_subtask(task_id, subtask_task_id)
-- VALUES
--   (2, 3),
--   (2, 4);

-- INSERT INTO public.relation_prereq(task_id, prereq_task_id)
-- VALUES
--   (2, 1),
--   (5, 4);

