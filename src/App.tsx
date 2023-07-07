import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'

import { ApolloClient, InMemoryCache, useQuery, gql } from '@apollo/client';

const client = new ApolloClient({
  uri: 'http://localhost:5433/graphql',
  cache: new InMemoryCache(),
});

type Task = {
  id: number,

  todo: string,

  subtasks: Task[],
  subtaskOf: Task[],
  prerequisites: Task[],
  prerequisiteOf: Task[]
}

/*
  TODO: modify this for re-use - 1-level-deep relation on all tasks

query AllTasksPlusOneLevelOfRelationsDeep {
  allTasks {
    nodes {
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
      id
    }
  }
}
*/

console.log('test');

function App() {
  const [count, setCount] = useState(0)

  const [test, setTest] = useState("test")


  // client
  //   .query({
  //     query: gql`
  const { loading, error, data } = useQuery(gql`
        query AllTasksPlusOneLevelOfRelationsDeep {
          allTasks {
            nodes {
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
              id
            }
          }
        }
      `,
    )
    // .then((result) => setTest(result.data.allTasks.nodes.map((node: any) => {
    //   console.log("For task_id: " + node.id)
    //   console.log("  has subtasks:")
    //   node.subtasks.nodes.map((subtask: any) => {
    //     console.log("   - " + subtask.subtaskTaskId)
    //   })

    //   console.log("  is subtask of:")
    //   node.subtaskOf.nodes.map((subtask: any) => {
    //     console.log("   - " + subtask.taskId)
    //   })

    //   console.log("  has prereqs:")
    //   node.prerequisites.nodes.map((subtask: any) => {
    //     console.log("   - " + subtask.prerequisiteTaskId)
    //   })

    //   console.log("  is prereq of:")
    //   node.prerequisiteOf.nodes.map((subtask: any) => {
    //     console.log("   - " + subtask.taskId)
    //   })
    // })));
    // .then((result) => setTest(result.data.allUsers.nodes.map((node: any) => node.firstName).join(', ')));

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error : {error.message}</p>;


  return (
    <>
      {
        data.allTasks.nodes.map((node: any) => {
          <textarea>
            {
              "For task_id: " + node.id + "\n" +
              "  has subtasks:" + "\n" +
              node.subtasks.nodes.map((subtask: any) => {
                "   - " + subtask.subtaskTaskId + "\n"
              }).join('') +

              "  is subtask of:" + "\n" +
              node.subtaskOf.nodes.map((subtaskOf: any) => {
                "   - " + subtaskOf.taskId
              }).join('') +

              "  has prereqs:" +
              node.prerequisites.nodes.map((prereq: any) => {
                "   - " + prereq.prerequisiteTaskId
              }).join('') +

              "  is prereq of:" +
              node.prerequisiteOf.nodes.map((prereqOf: any) => {
                "   - " + prereqOf.taskId
              }).join('')
            }
          </textarea>
        })
      }
    </>
  )

  // return (
  //   <>
  //     <div>
  //       <a href="https://vitejs.dev" target="_blank">
  //         <img src={viteLogo} className="logo" alt="Vite logo" />
  //       </a>
  //       <a href="https://react.dev" target="_blank">
  //         <img src={reactLogo} className="logo react" alt="React logo" />
  //       </a>
  //     </div>
  //     <h1>Vite + React</h1>
  //     <div className="card">
  //       <button onClick={() => setCount((count) => count + 1)}>
  //         count is {count}
  //       </button>
  //       <p>
  //         Edit blablah <code>src/App.tsx</code> and save to test HMR
  //       </p>

  //       <p>{test}</p>
  //     </div>
  //     <p className="read-the-docs">
  //       Click on the Vite and React logos to learn more
  //     </p>
  //   </>
  // )
}

export default App
