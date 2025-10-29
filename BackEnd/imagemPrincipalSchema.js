const mongoose = require("mongoose");

const imagemPrincipalSchema = new mongoose.Schema({
  imagem: { type: String, required: true }, // nome do arquivo original da img
  nome_imagem: { type: String, required: true }, // nome dado pelo admin
  descricao: { type: String, required: true }, // descrição da img feita pelo admin
  diretorios: [{ type: String, required: false }], // lista dos diretórios relacionados
  imagem_preview: { type: String, required: false }, // caminho pro preview
  zoom_maximo: { type: Number, required: true }, // zoom máximo permitido
});

module.exports = mongoose.model("ImagemPrincipal", imagemPrincipalSchema);
