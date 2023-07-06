# WIP

# Troubleshooting

If `npm run get:schema` seems to hang - check your `graphql_schema.json` file. If it is asking about installing `get-graphql-schema` then you need to CTRL+C to break the install and try running just `npx get-graphql-schema` by itself. That will get you the prompt to install, and once installed you can run `get:schema`.
