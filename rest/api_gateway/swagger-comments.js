/**
 * @swagger
 * tags:
 *   name: Cats
 *   description: Endpoints relacionados a gatos
 */

/**
 * @swagger
 * tags:
 *   name: Memes
 *   description: Endpoints relacionados a memes
 */

/**
 * @swagger
 * /cat:
 *   get:
 *     summary: Retorna informações sobre um gato aleatório.
 *     tags: [Cats]
 *     responses:
 *       200:
 *         description: OK. Retorna informações sobre um gato.
 *         content:
 *           application/json:
 *             example:
 *               id: "1a2b3c"
 *               url: "https://example.com/cat.jpg"
 */

/**
 * @swagger
 * /meme:
 *   get:
 *     summary: Retorna informações sobre um meme aleatório.
 *     tags: [Memes]
 *     responses:
 *       200:
 *         description: OK. Retorna informações sobre um meme.
 *         content:
 *           application/json:
 *             example:
 *               id: "xyz123"
 *               name: "Example Meme"
 *               url: "https://example.com/meme.jpg"
 */
