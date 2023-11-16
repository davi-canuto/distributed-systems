const soap = require("soap");
const readline = require("readline");

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

const wsdlUrl = "http://127.0.0.1:8000/tarot?wsdl";
const endpoint = "http://127.0.0.1:8000/tarot";

const clientOptions = {
  forceSoap12Headers: true,
  endpoint: endpoint,
};

soap.createClient(wsdlUrl, clientOptions, (err, client) => {
  if (err) {
    console.error(err);
    return;
  }

  console.log("You wanna tarot card for when?");
  console.log("1) past");
  console.log("2) present");
  console.log("3) future");
  console.log("4) all");

  rl.question("Enter option number: ", (choice) => {
    choice = parseInt(choice);

    let methodName, args;

    switch (choice) {
      case 1:
        methodName = "shuffleAndDeliverCards";
        args = { past: true, present: false, future: false, all: false };
        break;
      case 2:
        methodName = "shuffleAndDeliverCards";
        args = { past: false, present: true, future: false, all: false };
        break;
      case 3:
        methodName = "shuffleAndDeliverCards";
        args = { past: false, present: false, future: true, all: false };
        break;
      case 4:
        methodName = "shuffleAndDeliverCards";
        args = { past: false, present: false, future: false, all: true };
        break;
      default:
        console.log("Enter a valid option");
        rl.close();
        return;
    }

    client[methodName](args, (err, result) => {
      if (err) {
        console.error(err);
        rl.close();
        return;
      }

      const realRes = result.greeting;

      if (realRes.includes(",")) {
        const arrOfCards = realRes.split(",");

        console.log(`Card for representing your past is: ${arrOfCards[0]}`);
        console.log(`Card for representing your present is: ${arrOfCards[1]}`);
        console.log(`Card for representing your future is: ${arrOfCards[2]}`);
      } else {
        console.log(realRes);
      }

      rl.close();
    });
  });
});
