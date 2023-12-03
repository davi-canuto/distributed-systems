const express = require('express');
// const multer = require('multer');
const app = express();
const port = 3000;

// const storage = multer.memoryStorage();
// const upload = multer({ storage: storage });

app.post('/upload', upload.single('file'), (req, res) => {
  const file = req.file;
  if (!file) {
    return res.status(400).send('Nenhum arquivo enviado.');
  }

  res.status(200).send('Upload bem-sucedido!');
});

app.get('/download', (req, res) => {
  const fileBuffer = ;
  res.set('Content-Type', 'application/octet-stream');
  res.send(fileBuffer);
});

app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});
