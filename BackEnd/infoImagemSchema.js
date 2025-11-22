const mongoose = require("mongoose");

const infoImagemSchema = new mongoose.Schema(
  {
    nomeNaPasta: { type: String, required: true, unique: true },
    nomeImagem: { type: String, required: true },
    descricao: { type: String, required: true },

    diretorios: [{ type: mongoose.Schema.Types.ObjectId, ref: "Diretorio" }],
  },
  { timestamps: true }
);

module.exports = mongoose.model("InfoImagem", infoImagemSchema);
