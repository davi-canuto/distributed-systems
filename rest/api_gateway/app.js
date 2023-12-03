const express = require("express");
const {
  BlobServiceClient,
  StorageSharedKeyCredential,
} = require("@azure/storage-blob");
const multer = require("multer");

const app = express();
const port = 3000;

// Configurar o Azure Blob Storage
const accountName = "sua-conta-de-armazenamento";
const accountKey = "sua-chave-de-acesso";
const containerName = "seu-contêiner";
const sharedKeyCredential = new StorageSharedKeyCredential(
  accountName,
  accountKey
);
const blobServiceClient = new BlobServiceClient(
  `https://${accountName}.blob.core.windows.net`,
  sharedKeyCredential
);
const containerClient = blobServiceClient.getContainerClient(containerName);

// Configurar o multer para lidar com o upload de arquivos
const upload = multer();

// Endpoint para fazer upload de um arquivo
app.post("/upload", upload.single("file"), async (req, res) => {
  const file = req.file;
  if (!file) {
    return res.status(400).send("Nenhum arquivo enviado.");
  }

  const blobName = file.originalname;
  const blobClient = containerClient.getBlobClient(blobName);
  const data = file.buffer;

  try {
    await blobClient.uploadData(data, { overwrite: true });
    res.status(200).send("Upload bem-sucedido!");
  } catch (error) {
    console.error(error);
    res.status(500).send("Erro ao fazer upload do arquivo.");
  }
});

// Endpoint para baixar um arquivo
app.get("/download/:blobName", async (req, res) => {
  const blobName = req.params.blobName;
  const blobClient = containerClient.getBlobClient(blobName);

  try {
    const downloadResponse = await blobClient.download();
    const data = await streamToBuffer(downloadResponse.readableStreamBody);

    res.set("Content-Type", "application/octet-stream");
    res.send(data);
  } catch (error) {
    console.error(error);
    res.status(404).send("Arquivo não encontrado.");
  }
});

// Função auxiliar para converter um stream para buffer
async function streamToBuffer(readableStream) {
  return new Promise((resolve, reject) => {
    const chunks = [];
    readableStream.on("data", (data) => {
      chunks.push(data instanceof Buffer ? data : Buffer.from(data));
    });
    readableStream.on("end", () => {
      resolve(Buffer.concat(chunks));
    });
    readableStream.on("error", reject);
  });
}

// Iniciar o servidor
app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});
