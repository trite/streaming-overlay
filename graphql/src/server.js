const http = require("http");
const express = require("express");
const { postgraphile, makePluginHook } = require("postgraphile");
const cors = require("cors");

const { default: PgPubsub } = require("@graphile/pg-pubsub");

const app = express();

const corsOpts = {
  origin: '*',
};

app.use(cors(corsOpts));
app.options('*', cors(corsOpts));

const pluginHook = makePluginHook([PgPubsub]);

app.use(
    postgraphile(process.env.DATABASE_URL, "public", {
      pluginHook,
      watchPg: true,
      graphiql: true,
      enhanceGraphiql: true,
      retryOnInitFail: true,
      subscriptions: true,
      simpleSubscriptions: true, // Add the `listen` subscription field
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