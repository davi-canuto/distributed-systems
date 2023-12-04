const express = require("express");
const axios = require("axios");
const app = express();
const port = 3000;
const catsUrl = "https://api.thecatapi.com/v1/images/search";
const memesUrl = "https://api.imgflip.com/get_memes";

app.get("/cats", async (req, res) => {
  try {
    const response = await axios.get(catsUrl);

    res.send(response.data[0]);
  } catch (error) {
    res.send(error);
  }
});

app.get("/memes", async (req, res) => {
  try {
    const response = await axios.get(memesUrl);

    const items = response.data.data.memes;

    var randomObject = items[Math.floor(Math.random() * items.length)];

    res.send(randomObject);
  } catch (error) {
    res.send(error);
  }
});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
