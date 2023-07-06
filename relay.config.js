module.exports = {
  src: "./src", // Path to the folder containing your ReScript files
  schema: "./schema.graphql", // Path to the schema.graphql you've exported from your API. Don't know what this is? It's a saved introspection of what your schema looks like. You can run `npx get-graphql-schema http://path/to/my/graphql/server > schema.graphql` in your root to generate it
  artifactDirectory: "./src/__generated__", // The directory where all generated files will be emitted

  // Needed for compatibility with postgraphile I think? 
  //   Found because of the error in this issue: https://github.com/facebook/relay/issues/3807
  // TODO: Doesn't belong here, but not sure where yet either...
  nodeInterfaceIdField: "nodeId",

  // You can add type definitions for custom scalars here.
  // Whenever a custom scalar is encountered, the type emitted will correspond to the definition defined here. You can then deal with the type as needed when accessing the data.
  customScalars: {
    Datetime: "string",
    Color: "Color.t",
  },
};