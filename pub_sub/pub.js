const amqp = require('amqplib/callback_api');

amqp.connect('amqp://127.0.0.1', function (err, conn) {
  conn.createChannel(function (err, ch) {
    var ex = 'pub_sub_distributed';
    var msg = process.argv.slice(2).join(' ') || 'Hello World!';

    ch.assertExchange(ex, 'fanout', { durable: false });
    ch.publish(ex, '', new Buffer(msg));
    console.log(" [x] Sent %s", msg);
  });

  setTimeout(function () { conn.close(); process.exit(0) }, 500);
})