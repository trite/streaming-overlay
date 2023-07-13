import { graphql } from 'relay-runtime';
import './App.css';
import { useLazyLoadQuery } from 'react-relay';
import { AppQuery as AppQueryType } from './__generated__/AppQuery.graphql';
import React from 'react';

const AppQuery = graphql`
  query AppQuery {
    allMarkdownChunks {
      nodes {
        id
        chunkName
        markdown
        createdAt
        updatedAt
      }
    }
  }
`;

function Loading() {
  return <div>Loading...</div>;
}

export default function App() {
  return (
    <div>
      <React.Suspense fallback={<Loading />}>
        <div>
          <p>some text</p>
        </div>
      </React.Suspense>
    </div>
  );
}
