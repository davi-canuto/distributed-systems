const { execSync } = require('child_process');
const axios = require("axios");
const amqp = require('amqplib/callback_api');

const catsUrl = "https://api.thecatapi.com/v1/images/search";

amqp.connect('amqp://127.0.0.1', function (err, conn) {
  conn.createChannel(async function (err, ch) {
    const catExchange = 'cats';

    ch.assertExchange(catExchange, 'fanout', { durable: false });

    while (true) {
      const catResponse = await axios.get(catsUrl)

      const catMsg = catResponse.data[0].url

      ch.publish(catExchange, '', new Buffer(catMsg));
      console.log("Sent messages for publishers in cats topics.");
      execSync('sleep 4');
    }
  });
  // setTimeout(function () { conn.close(); process.exit(0) }, 500);
})