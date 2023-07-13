import { graphql } from 'relay-runtime';
import './App.css';
import { useLazyLoadQuery } from 'react-relay';
import { AppQuery as AppQueryType } from './__generated__/AppQuery.graphql';
import React from 'react';
import MarkdownChunk from './MarkdownChunk';

const AppQuery = graphql`
  query AppQuery {
    allActiveMarkdownChunks(first: 1, orderBy: UPDATED_AT_DESC) {
      nodes {
        markdownChunkByChunkName {
          chunkId: id
          ...MarkdownChunkFragment
        }
      }
    }
  }
`;

function Loading() {
  return <div>Loading...</div>;
}

export default function App() {
  const data = useLazyLoadQuery<AppQueryType>(AppQuery, {});

  return (
    <React.Suspense fallback={<Loading />}>
      <div>
        {data.allActiveMarkdownChunks?.nodes.map((node) => {
          const chunk = node?.markdownChunkByChunkName;

          if (chunk === null || chunk === undefined) {
            return (
              <div>
                <p>OH NOES SOMETHING WENT WRONG</p>
              </div>
            );
          }

          return <MarkdownChunk key={chunk?.chunkId} markdownChunk={chunk} />;
        })}
      </div>
    </React.Suspense>
  );
}
