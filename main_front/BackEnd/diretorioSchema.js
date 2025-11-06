const mongoose = require('mongoose')

const diretorioSchema = new mongoose.Schema({
  titulo: { type: String, required: true, trim: true },
  descricao: { type: String, required: true, trim: true },
  listIMG: { type: [String], required: false },
});

module.exports = mongoose.model('Diretorio', diretorioSchema);