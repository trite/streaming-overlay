// TODO: Get rid of this whole file, make a `Task` component
//         that actually corresponds to an individual task

import React from 'react';
import {
  Task,
  TaskWithRelsFragment,
  fromTaskFragment,
  TaskStatus,
} from './Task';
import * as O from 'fp-ts/Option';
import * as A from 'fp-ts/Array';
import {
  TaskWithRelsFragment$data,
  TaskWithRelsFragment$key,
} from './__generated__/TaskWithRelsFragment.graphql';
import { useFragment } from 'react-relay';
import fromReadonly from './utils/Mutability';
import { fromRecord, toRecord } from 'fp-ts/lib/ReadonlyRecord';
import { pipe } from 'fp-ts/lib/function';

function test(x: ReadonlyArray<Task>): Array<Task> {
  return x as Array<Task>;
}

function RelationInfo({
  title,
  relatedTasks,
}: {
  readonly title: string;
  relatedTasks: O.Option<ReadonlyArray<Task>>;
}): React.ReactElement {
  return pipe(
    relatedTasks,
    O.map(test),
    // O.map((tasks) => tasks.map((task) => ))
    O.map(
      A.map((task) => {
        return (
          <li>
            <TaskBox task={task} />
          </li>
        );
      })
    )
  );
  // return O.match(
  //   () => <div></div>,
  //   (tasks: Task[]) => (
  //     <div>
  //       <p>{title}</p>
  //       <ul>
  //         {tasks.map((task) => (
  //           <li>{task.taskId}</li>
  //         ))}
  //       </ul>
  //     </div>
  //   )
  //   // )(toRecord(fromRecord(relatedTasks)));
  // )(O.map((x) => toRecord(x)))(relatedTasks);
}

// const TaskFragment

export type Props = {
  task: TaskWithRelsFragment$key;
};

export default function TaskBox({ task }: Props) {
  const data = useFragment(TaskWithRelsFragment, task);

  return (
    <div>
      <p>{data.taskId}</p>
      <p>{data.toDo}</p>
      <p>{data.status}</p>
      {/* <RelationInfo title="Subtasks" relatedTasks={data.subtasks} /> */}
      {data.subtasks.nodes[0]?.taskBySubtaskTaskId != null &&
      data.subtasks.nodes[0]?.taskBySubtaskTaskId != undefined ? (
        <RelationInfo
          title="Subtasks"
          relatedTasks={fromReadonly(
            O.sequenceArray(
              data.subtasks.nodes.map((node) =>
                fromTaskFragment(node?.taskBySubtaskTaskId)
              )
            )
          )}
        />
      ) : (
        <></>
      )}
      <RelationInfo title="Subtask of" relatedTasks={data.subtaskOf} />
      <RelationInfo title="Prereqs" relatedTasks={data.prereqs} />
      <RelationInfo title="Prereq of" relatedTasks={data.prereqOf} />
    </div>
  );
}
