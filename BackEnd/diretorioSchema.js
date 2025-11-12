const mongoose = require("mongoose");

const diretorioSchema = new mongoose.Schema({
  titulo: { type: String, required: true, trim: true },
  descricao: { type: String, required: true, trim: true },
  listIMG: { type: [String], required: false },
  id: { type: Double, required: true, trim: true },
});

module.exports = mongoose.model("Diretorio", diretorioSchema);
