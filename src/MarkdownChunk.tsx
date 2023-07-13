import { graphql } from 'relay-runtime';

import { MarkdownChunkFragment$key } from './__generated__/MarkdownChunkFragment.graphql';
import { useFragment } from 'react-relay';

import { marked } from 'marked';

import DOMPurify from 'dompurify';

const MarkdownChunkFragment = graphql`
  fragment MarkdownChunkFragment on MarkdownChunk {
    chunkId: id
    chunkName
    markdown
    createdAt
    updatedAt
  }
`;

type Props = {
  markdownChunk: MarkdownChunkFragment$key;
};

export default function MarkdownChunk({ markdownChunk }: Props) {
  const data = useFragment(MarkdownChunkFragment, markdownChunk);

  const parsedMarkdown = DOMPurify.sanitize(marked.parse(data.markdown));

  return (
    <div className="markdown-chunk-outer-container">
      <div
        className="markdown-chunk-container"
        dangerouslySetInnerHTML={{ __html: parsedMarkdown }}
      ></div>
    </div>
  );
}
