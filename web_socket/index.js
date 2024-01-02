const http = require('http');
const staticHandler = require('serve-handler');
const WebSocket = require('ws');

const server = http.createServer((req, res) => {
  return staticHandler(req, res, { public: 'public' });
});

const wss = new WebSocket.Server({ server });

wss.on('connection', (client) => {
  console.log('Client connected!');
  client.on('message', (msg) => {
    console.log(`Message: ${msg}`);
    broadcast(msg);
  });
});

function broadcast(msg) {
  for (const client of wss.clients) {
    if (client.readyState === WebSocket.OPEN) {
      client.send(msg);
    }
  }
}

server.listen(process.argv[2] || 8080, '127.0.0.1', () => {
  // http://127.0.0.1:8080/
  console.log('Server listening...');
});