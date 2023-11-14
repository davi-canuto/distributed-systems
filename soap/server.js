const SOAP = require("soap");
const http = require("http");

const WSDL_PATH = "./tarotService.wsdl";
const WSDL_DEFINITION = require("fs").readFileSync(WSDL_PATH, "utf8");

const service = {
  SimpleService: {
    SimpleServicePortType: {
      GetHelloString: function (args) {
        console.log("Received request:", args);
        try {
          // Sua lógica de processamento aqui
          console.log("Response sent successfully.");
          return {
            result: "Hello, World!",
          };
        } catch (error) {
          console.error("Error processing request:", error);
          throw error;
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
