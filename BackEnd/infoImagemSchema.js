const mongoose = require('mongoose')

const infoImagemSchema = new mongoose.Schema({
  nomeNaPasta: { type: String, required: true, trim: true, unique: true },
  nomeImagem:  { type: String, required: true, trim: true },
  descricao:   { type: String, required: true, trim: true },
  qtdNiveis: {
    type: Number,
    required: true,
    min: 0,
    validate: {
      validator: Number.isInteger,
      message: props => `${props.value} não é um inteiro válido`
    }
  }
}, { timestamps: true })

module.exports = mongoose.model('InfoImagem', infoImagemSchema);