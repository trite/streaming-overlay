import * as O from 'fp-ts/Option';
import { graphql } from 'relay-runtime';
import { TaskWithRelsFragment$data } from './__generated__/TaskWithRelsFragment.graphql';

export type TaskStatus = 'TODO' | 'BLOCKED' | 'IN_PROGRESS' | 'DONE';

export type Task = {
  taskId: number;
  toDo: string;
  status: TaskStatus;
};

export type TaskWithRels = Task & {
  subtasks: O.Option<Task[]>;
  subtaskOf: O.Option<Task[]>;
  prereqs: O.Option<Task[]>;
  prereqOf: O.Option<Task[]>;
};

export const TaskFragment = graphql`
  fragment TaskFragment on Task {
    taskId: id
    toDo
    status
  }
`;

export const TaskWithRelsFragment = graphql`
  fragment TaskWithRelsFragment on Task {
    taskId: id
    toDo
    status
    subtasks {
      nodes {
        taskBySubtaskTaskId {
          taskId: id
          toDo
          status
        }
      }
    }
    subtaskOf {
      nodes {
        taskByTaskId {
          taskId: id
          toDo
          status
        }
      }
    }
    prereqs {
      nodes {
        taskByPrereqTaskId {
          taskId: id
          toDo
          status
        }
      }
    }
    prereqOf {
      nodes {
        taskByTaskId {
          taskId: id
          toDo
          status
        }
      }
    }
  }
`;

function taskStatusFromFragment(
  status: TaskWithRelsFragment$data['status']
): O.Option<TaskStatus> {
  switch (status) {
    case 'TODO':
      return O.some('TODO');
    case 'IN_PROGRESS':
      return O.some('IN_PROGRESS');
    case 'DONE':
      return O.some('DONE');
    default:
      return O.none;
  }
}

export function fromTaskFragment(
  task:
    | {
        taskId: number;
        toDo: string;
        status: TaskWithRelsFragment$data['status'];
      }
    | null
    | undefined
): O.Option<Task> {
  if (task === null || task === undefined) {
    return O.none;
  }

  return O.map((status: TaskStatus) => ({
    taskId: task.taskId,
    toDo: task.toDo,
    status,
  }))(taskStatusFromFragment(task.status));
}
