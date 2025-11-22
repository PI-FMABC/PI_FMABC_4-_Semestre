const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const { getPreviewImagePath } = require("./previewHelper");
const path = require("path");
require("dotenv").config();

const app = express();
app.use(express.json());
app.use(cors());

// Permite acesso público às pastas dentro de Tiles
app.use("/tiles", express.static(path.join(__dirname, "../Tiles")));

// Schemas
const Diretorio = require("./diretorioSchema");
const InfoImagem = require("./infoImagemSchema");

const PORT = process.env.PORT || 3000;

// Conexão com o MongoDB e inicializa servidor somente após conectar
async function start() {
  try {
    await mongoose.connect(process.env.MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log("Conectado ao MongoDB");

    app.listen(PORT, () =>
      console.log(`Servidor rodando em http://localhost:${PORT}`)
    );
  } catch (err) {
    console.error("MongoDB erro de conexão:", err);
    process.exit(1);
  }
}
start();

// Teste de status da API
app.get("/test", async (req, res) => {
  try {
    const dbStatus = mongoose.connection.readyState; // 1 = conectado
    res.json({
      message: "API funcionando!",
      mongoStatus: dbStatus === 1 ? "Conectado ao MongoDB" : "Desconectado",
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/// ======================= ROTAS DE DIRETÓRIO =======================

// Criar diretório com vinculação de imagens
app.post("/diretorio", async (req, res) => {
  try {
    const { titulo, descricao, listIMG = [] } = req.body;
    const item = new Diretorio({ titulo, descricao, listIMG });
    const respMongo = await item.save();

    if (listIMG.length > 0) {
      await InfoImagem.updateMany(
        { _id: { $in: listIMG } },
        { $addToSet: { diretorios: respMongo._id } }
      );
    }

    res.status(201).json(respMongo);
  } catch (erro) {
    res.status(400).json({ erro: erro.message });
  }
});

// Listar diretórios com preview das imagens
app.get("/diretorio", async (req, res) => {
  try {
    const itens = await Diretorio.find().populate("listIMG");
    const itensComPreview = itens.map((d) => ({
      ...d.toObject(),
      listIMG: d.listIMG.map((img) => ({
        ...img.toObject(),
        previewPath: (() => {
          try {
            return getPreviewImagePath(img.nomeNaPasta);
          } catch (e) {
            return "";
          }
        })(),
      })),
    }));
    res.status(200).json(itensComPreview);
  } catch (erro) {
    res.status(500).json({ erro: erro.message });
  }
});

// Buscar diretório pelo ID
app.get("/diretorio/:id", async (req, res) => {
  try {
    const item = await Diretorio.findById(req.params.id).populate("listIMG");
    if (!item) return res.status(404).json({ erro: "Item não encontrado" });
    const itemComPreview = {
      ...item.toObject(),
      listIMG: item.listIMG.map((img) => ({
        ...img.toObject(),
        previewPath: (() => {
          try {
            return getPreviewImagePath(img.nomeNaPasta);
          } catch (e) {
            return "";
          }
        })(),
      })),
    };
    res.status(200).json(itemComPreview);
  } catch (erro) {
    res.status(500).json({ erro: erro.message });
  }
});

// Atualizar diretório
app.put("/diretorio/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const { titulo, descricao, listIMG = [] } = req.body;

    const diretorio = await Diretorio.findById(id);
    if (!diretorio)
      return res.status(404).json({ erro: "Item não encontrado" });

    // Remove vínculo antigo das imagens
    await InfoImagem.updateMany(
      { _id: { $in: diretorio.listIMG } },
      { $pull: { diretorios: id } }
    );

    diretorio.titulo = titulo;
    diretorio.descricao = descricao;
    diretorio.listIMG = listIMG;
    await diretorio.save();

    // Adiciona vínculo novo
    if (listIMG.length > 0) {
      await InfoImagem.updateMany(
        { _id: { $in: listIMG } },
        { $addToSet: { diretorios: id } }
      );
    }

    res.status(200).json(diretorio);
  } catch (erro) {
    res.status(500).json({ erro: erro.message });
  }
});

// Deletar diretório
app.delete("/diretorio/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const diretorio = await Diretorio.findByIdAndDelete(id);
    if (!diretorio)
      return res.status(404).json({ erro: "Item não encontrado" });

    await InfoImagem.updateMany(
      { _id: { $in: diretorio.listIMG } },
      { $pull: { diretorios: id } }
    );

    res.status(200).json({ message: "Item removido", item: diretorio });
  } catch (erro) {
    res.status(500).json({ erro: erro.message });
  }
});

/// ======================= ROTAS DE INFOIMAGEM =======================

// Criar imagem com vinculação a diretórios
app.post("/infoimagem", async (req, res) => {
  try {
    const { nomeNaPasta, nomeImagem, descricao, diretorios = [] } = req.body;
    const imagem = new InfoImagem({
      nomeNaPasta,
      nomeImagem,
      descricao,
      diretorios,
    });
    const respMongo = await imagem.save();

    if (diretorios.length > 0) {
      await Diretorio.updateMany(
        { _id: { $in: diretorios } },
        { $addToSet: { listIMG: respMongo._id } }
      );
    }

    res.status(201).json(respMongo);
  } catch (erro) {
    res.status(400).json({ erro: erro.message });
  }
});

// Listar todas as imagens com preview
app.get("/infoimagem", async (req, res) => {
  try {
    const imagens = await InfoImagem.find().populate("diretorios");
    const imagensComPreview = imagens.map((img) => ({
      ...img.toObject(),
      previewPath: (() => {
        try {
          return getPreviewImagePath(img.nomeNaPasta);
        } catch (e) {
          return "";
        }
      })(),
    }));
    res.status(200).json(imagensComPreview);
  } catch (erro) {
    res.status(500).json({ erro: erro.message });
  }
});

// Buscar imagem pelo ID
app.get("/infoimagem/:id", async (req, res) => {
  try {
    const imagem = await InfoImagem.findById(req.params.id).populate(
      "diretorios"
    );
    if (!imagem) return res.status(404).json({ erro: "Imagem não encontrada" });

    const imagemComPreview = {
      ...imagem.toObject(),
      previewPath: (() => {
        try {
          return getPreviewImagePath(imagem.nomeNaPasta);
        } catch (e) {
          return "";
        }
      })(),
    };

    res.status(200).json(imagemComPreview);
  } catch (erro) {
    res.status(500).json({ erro: erro.message });
  }
});

// Atualizar imagem
app.put("/infoimagem/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const { nomeNaPasta, nomeImagem, descricao, diretorios = [] } = req.body;

    const imagem = await InfoImagem.findById(id);
    if (!imagem) return res.status(404).json({ erro: "Imagem não encontrada" });

    // Remove vínculo antigo
    await Diretorio.updateMany(
      { _id: { $in: imagem.diretorios } },
      { $pull: { listIMG: id } }
    );

    imagem.nomeNaPasta = nomeNaPasta;
    imagem.nomeImagem = nomeImagem;
    imagem.descricao = descricao;
    imagem.diretorios = diretorios;
    await imagem.save();

    // Adiciona vínculo novo
    if (diretorios.length > 0) {
      await Diretorio.updateMany(
        { _id: { $in: diretorios } },
        { $addToSet: { listIMG: id } }
      );
    }

    res.status(200).json(imagem);
  } catch (erro) {
    res.status(500).json({ erro: erro.message });
  }
});

// Deletar imagem
app.delete("/infoimagem/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const imagem = await InfoImagem.findByIdAndDelete(id);
    if (!imagem) return res.status(404).json({ erro: "Imagem não encontrada" });

    await Diretorio.updateMany(
      { _id: { $in: imagem.diretorios } },
      { $pull: { listIMG: id } }
    );

    res.status(200).json({ message: "Imagem removida", imagem });
  } catch (erro) {
    res.status(500).json({ erro: erro.message });
  }
});

// Middleware de erro genérico
app.use((err, req, res, next) => {
  console.error("Unhandled error:", err);
  res.status(err.status || 500).json({ erro: err.message || "Erro interno" });
});
