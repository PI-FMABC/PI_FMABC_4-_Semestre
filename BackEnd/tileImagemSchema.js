const mongoose = require("mongoose");

const tileImagemSchema = new mongoose.Schema({
  nome_arquivo: { type: String, required: true }, // nome da imagem original
  nivel_de_zoom: { type: Number, required: true }, // nível de zoom
  nome_tile: { type: String, required: true }, // "X_Y.jpg"
  caminho_tile: { type: String, required: true }, // caminho do arquivo
});

module.exports = mongoose.model("TileImagem", tileImagemSchema);
