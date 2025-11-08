const mongoose = require('mongoose')

const infoImagemSchema = new mongoose.Schema({
  nomeNaPasta: { type: String, required: true, trim: true, unique: true },
  nomeImagem:  { type: String, required: true, trim: true },
  descricao:   { type: String, required: true, trim: true },
}, { timestamps: true })

module.exports = mongoose.model('InfoImagem', infoImagemSchema);