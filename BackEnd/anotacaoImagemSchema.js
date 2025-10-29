const mongoose = require('mongoose');

const anotacaoImagemSchema = new mongoose.Schema({
  imagem: { type: String, required: true }, // nome do arquivo original
  anotacao: { type: String, required: true }, // anotação
  regiao: {
    type: [[Number]], // [[x0, y0], [x1, y1]]
    validate: {
      validator: function (arr) {
        return arr.length === 2 && arr.every(p => p.length === 2);
      },
      message: 'A região deve conter dois pontos [[x0, y0], [x1, y1]].',
    },
    required: true,
  },
});

module.exports = mongoose.model('AnotacaoImagem', anotacaoImagemSchema);
