const http = require("http");
const express = require("express");
const { postgraphile } = require("postgraphile");
const cors = require("cors");

const app = express();

// const options = {
//   origin: 'http://localhost:5173'
// }
// app.use(cors(options));
// Enable pre-flight requests for all routes
// app.options('*', cors(options));

app.use(cors());


app.use(
    postgraphile(process.env.DATABASE_URL, "public", {
      watchPg: true,
      graphiql: true,
      enhanceGraphiql: true,
      retryOnInitFail: true,
    })
);

http.createServer(app).listen(process.env.GRAPHQL_PORT);