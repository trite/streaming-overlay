import { graphql } from 'relay-runtime';
import './App.css';
import { useLazyLoadQuery } from 'react-relay';
import { AppQuery as AppQueryType } from './__generated__/AppQuery.graphql';
import React from 'react';
import * as R from './utils/Result.ts';
// import * as O from 'fp-ts/Option';
// import { Task } from './Task';
import TaskBox from './TaskBox.tsx';

const AppQuery = graphql`
  query AppQuery {
    allTasks {
      nodes {
        taskId: id
        ...TaskWithRelsFragment
      }
    }
  }
`;

/*
Example of how prereqs should work:

Tasks for today:
- [X] Do the first thing
- [ ] Do the second thing whenever
- [ ] Do the third thing, only after the first thing is done // this is shown but grayed out
- [ ] Do the fourth thing, only after the second thing is done // this is shown but grayed out
- [ ] Do the fifth thing, only after the third thing is done // not shown until the first thing is done
- [ ] Do the sixth thing, only after the fourth thing is done // not shown until the second thing is done

Upon completing task 1 or 2
  Task 3 or 4 is no longer grayed out
  Task 5 or 6 is now shown, but is grayed out

  This shouldn't be too bad to achieve by simply traversing any "prereqOf" relationships
    until you find a task that is not completed, then grabbing the next "prereqOf" entries
    to find the next tasks to show (but grayed out or otherwise marked as "unavailable to do" yet). 
*/

// const example: Task = {
//   taskId: 1,
//   toDo: 'Do the thing',
//   status: 'TODO',
//   subtasks: O.none,
//   subtaskOf: O.none,
//   prereqs: O.none,
//   prereqOf: O.some([
//     {
//       taskId: 2,
//       toDo: 'Do the other thing',
//       status: 'TODO',
//       subtasks: O.none,
//       subtaskOf: O.none,
//       prereqs: O.none,
//       prereqOf: O.none,
//     }, // satisfies Task.Task,
//   ]),
// };

// TODO: Make function to convert from GraphQL response to Task type

function TaskList() {
  const data = useLazyLoadQuery<AppQueryType>(AppQuery, {});

  return (
    <div className={'task-box-div-container'}>
      <p>{`Task count: ${data.allTasks?.nodes.length}`}</p>
      {data.allTasks?.nodes.map((task) => {
        if (task == null) return <div>Task is null</div>; // TODO: Make this a proper error message
        return <TaskBox key={task.taskId} task={task} />;
      })}
    </div>
  );
}

function Loading() {
  return <div>Loading...</div>;
}

export default function App() {
  return (
    <div>
      <React.Suspense fallback={<Loading />}>
        <TaskList />
      </React.Suspense>
    </div>
  );
}

const test: R.Result<number> =
  Math.random() > 0.5 ? R.Err(new Error('OH NOES')) : R.Ok(1);

function checkThings(test: R.Result<number>) {
  return R.match(
    (result) => 'ok: ' + result,
    (error) => 'err: ' + error
  )(test);
}

console.log(checkThings(test));
