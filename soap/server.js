const SOAP = require("soap");
const http = require("http");

const WSDL_PATH = "./tarotService.wsdl";
const WSDL_DEFINITION = require("fs").readFileSync(WSDL_PATH, "utf8");

const arrayOfCards = require("./tarotCards");

const service = {
  Tarot_Service: {
    Tarot_Port: {
      shuffleAndDeliverCards: function (args) {
        if (args.past.toLowerCase() === "true") {
          return {
            greeting: arrayOfCards.find(
              (_, i, ar) => Math.random() < 1 / (ar.length - i)
            )["name"],
          };
        } else if (args.present.toLowerCase() === "true") {
          return {
            greeting: arrayOfCards.find(
              (_, i, ar) => Math.random() < 1 / (ar.length - i)
            )["name"],
          };
        } else if (args.future.toLowerCase() === "true") {
          return {
            greeting: arrayOfCards.find(
              (_, i, ar) => Math.random() < 1 / (ar.length - i)
            )["name"],
          };
        } else if (args.all.toLowerCase() === "true") {
          let cards = [];

          while (cards.length < 3) {
            const sampleCardIndex = Math.floor(
              Math.random() * arrayOfCards.length
            );
            const sampleCard = arrayOfCards[sampleCardIndex]["name"];
            if (!cards.includes(sampleCard)) {
              cards.push(sampleCard);
            }
          }

          return {
            greeting: cards.join(","),
          };
        }
      },
    },
  },
};

const server = http.createServer(function (req, res) {
  res.end("404: Not Found: " + req.url);
});

server.listen(8000);
SOAP.listen(server, "/tarot", service, WSDL_DEFINITION);

console.log("SOAP server running in http://127.0.0.1:8000/tarot?wsdl");
