\connect streaming-overlay;

INSERT INTO public.task(to_do)
VALUES
  ('Convert app to TypeScript/Postgres/GraphQL'),
  ('Create `Control` and `Display` pages'),
  ('Create `Control` page'),
  ('Create `Display` page'),
  ('Wire up subscriptions to `Display` page');

INSERT INTO public.relation_subtask(task_id, subtask_task_id)
VALUES
  (2, 3),
  (2, 4);

INSERT INTO public.relation_prereq(task_id, prereq_task_id)
VALUES
  (2, 1),
  (5, 4);

