import { graphql } from 'relay-runtime';
import './App.css';

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
        subtasks {
          nodes {
            subtaskTaskId
          }
        }
        subtaskOf {
          nodes {
            taskId
          }
        }
        prerequisites {
          nodes {
            prerequisiteTaskId
          }
        }
        prerequisiteOf {
          nodes {
            taskId
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

function App() {
  return (
    <>
      <p>testing</p>
      <pre>{textAreaValue}</pre>
      <p>testing2</p>
    </>
  );
}

export default App;
