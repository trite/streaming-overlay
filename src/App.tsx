import { graphql } from 'relay-runtime';
import './App.css';
import { useLazyLoadQuery } from 'react-relay';
import { AppQuery as AppQueryType } from './__generated__/AppQuery.graphql';
import React from 'react';

// type Task = {
//   id: number;
//   todo: string;
//   subtasks: Task[];
//   subtaskOf: Task[];
//   prerequisites: Task[];
//   prerequisiteOf: Task[];
// };

const AppQuery = graphql`
  query AppQuery {
    allTasks {
      nodes {
        id
        toDo
        status
        subtasks {
          nodes {
            taskBySubtaskTaskId {
              id
              toDo
              status
            }
          }
        }
        subtaskOf {
          nodes {
            taskByTaskId {
              id
              toDo
              status
            }
          }
        }
        prerequisites {
          nodes {
            taskByPrerequisiteTaskId {
              id
              toDo
              status
            }
          }
        }
        prerequisiteOf {
          nodes {
            taskByTaskId {
              id
              toDo
              status
            }
          }
        }
      }
    }
  }
`;

/*
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

  This shouldn't be too bad to achieve by simply traversing any "prerequisiteOf" relationships
    until you find a task that is not completed, then grabbing the next "prerequisiteOf" entries
    to find the next tasks to show (but grayed out or otherwise marked as "unavailable to do" yet). 
*/

// function TaskBox(task: ) {
//   return <div></div>;
// }

function TaskList() {
  const data = useLazyLoadQuery<AppQueryType>(AppQuery, {});

  return (
    <div className={'task-box-div-container'}>
      <p>{`Task count: ${data.allTasks?.nodes.length}`}</p>
      {data.allTasks?.nodes.map((task) => {
        return (
          <div key={task?.taskId} className={'task-box-div'}>
            <p>{task?.toDo}</p>
          </div>
        );
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
