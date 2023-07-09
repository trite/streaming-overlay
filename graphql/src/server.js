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


/* START: Graceful shutdown */
// The signals we want to handle
var signals = {
  'SIGHUP': 1,
  'SIGINT': 2,
  'SIGTERM': 15
};

// Do any necessary shutdown logic for our application here
const shutdown = (signal, value) => {
  console.log("shutdown!");
  server.close(() => {
    console.log(`server stopped by ${signal} with value ${value}`);
    process.exit(128 + value);
  });
};

// Create a listener for each of the signals that we want to handle
Object.keys(signals).forEach((signal) => {
  process.on(signal, () => {
    console.log(`process received a ${signal} signal`);
    shutdown(signal, signals[signal]);
  });
});
/* END: Graceful shutdown */