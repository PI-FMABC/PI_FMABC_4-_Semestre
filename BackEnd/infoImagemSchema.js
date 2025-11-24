const mongoose = require("mongoose");

const infoImagemSchema = new mongoose.Schema(
  {
    nomeNaPasta: { type: String, required: true, unique: true },
    nomeImagem: { type: String, required: true },
    descricao: { type: String, required: true },

    diretorios: [{ type: mongoose.Schema.Types.ObjectId, ref: "Diretorio" }],
    
    // tamanhoNiveis: {
    //   type: Map,
    //   of: new mongoose.Schema({
    //     width: {type: Number, required: true},
    //     width: {type: Number, required: true}
    //   }, {_id: false})
    // }
  },
  { timestamps: true }
);

module.exports = mongoose.model("InfoImagem", infoImagemSchema);
