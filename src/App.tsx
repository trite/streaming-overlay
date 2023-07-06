import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'

import { ApolloClient, InMemoryCache, ApolloProvider, gql } from '@apollo/client';

const client = new ApolloClient({
  uri: 'http://localhost:5433/graphql',
  cache: new InMemoryCache(),
});


console.log('test');

function App() {
  const [count, setCount] = useState(0)

  const [test, setTest] = useState("test")


  client
    .query({
      query: gql`
        query MyQuery {
          allUsers {
            nodes {
              firstName
              id
              lastName
              userName
            }
          }
        }
      `,
    })
    .then((result) => setTest(result.data.allUsers.nodes.map((node: any) => node.firstName).join(', ')));


  return (
    <>
      <div>
        <a href="https://vitejs.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Vite + React</h1>
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
        <p>
          Edit blablah <code>src/App.tsx</code> and save to test HMR
        </p>

        <p>{test}</p>
      </div>
      <p className="read-the-docs">
        Click on the Vite and React logos to learn more
      </p>
    </>
  )
}

export default App
