const express = require("express");
const cors = require("cors");
const axios = require("axios");
const app = express();
const port = 3000;
const catsUrl = "https://api.thecatapi.com/v1/images/search";
const memesUrl = "https://api.imgflip.com/get_memes";

app.use(cors());

app.get("/cat", async (req, res) => {
  try {
    const response = await axios.get(catsUrl);

    res.send(response.data[0]);
  } catch (error) {
    res.send(error);
  }
});

app.get("/meme", async (req, res) => {
  try {
    const response = await axios.get(memesUrl);

    const items = response.data.data.memes;

    var randomObject = items[Math.floor(Math.random() * items.length)];

    res.send(randomObject);
  } catch (error) {
    res.send(error);
  }
});

// const options = {
//   definition: {
//     openapi: "3.0.0",
//     info: {
//       title: "API Gateway",
//       version: "1.0.0",
//     },
//   },
//   apis: ["./seu-arquivo-com-comentarios.js"],
// };

// const swaggerSpec = swaggerJsdoc(options);
// app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerSpec));

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
