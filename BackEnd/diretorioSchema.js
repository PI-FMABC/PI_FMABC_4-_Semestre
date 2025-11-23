const mongoose = require("mongoose");

const diretorioSchema = new mongoose.Schema(
  {
    titulo: { type: String, required: true },
    descricao: { type: String, required: true },
    listIMG: [{ type: mongoose.Schema.Types.ObjectId, ref: "InfoImagem" }],
  },
  { timestamps: true }
);

module.exports = mongoose.model("Diretorio", diretorioSchema);
