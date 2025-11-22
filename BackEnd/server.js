const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const path = require("path");
require("dotenv").config();

const { getPreviewImagePath } = require("./previewHelper"); // Função que retorna caminho do preview
const Diretorio = require("./diretorioSchema");
const InfoImagem = require("./infoImagemSchema");

const app = express();
app.use(express.json());
app.use(cors());

// Servir a pasta Tiles para previews
app.use("/tiles", express.static(path.join(__dirname, "../Tiles")));

const PORT = process.env.PORT || 3000;

// Conexão MongoDB
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
    console.error("Erro de conexão com MongoDB:", err);
    process.exit(1);
  }
}
start();

// Rota de teste
app.get("/test", (req, res) => {
  const dbStatus = mongoose.connection.readyState;
  res.json({
    message: "API funcionando!",
    mongoStatus: dbStatus === 1 ? "Conectado ao MongoDB" : "Desconectado",
  });
});

/// ======================= ROTAS DE DIRETÓRIO =======================

// Criar diretório
app.post("/diretorio", async (req, res) => {
  try {
    const { titulo, descricao, listIMG = [] } = req.body;
    const dir = new Diretorio({ titulo, descricao, listIMG });
    const resp = await dir.save();

    if (listIMG.length > 0) {
      await InfoImagem.updateMany(
        { _id: { $in: listIMG } },
        { $addToSet: { diretorios: resp._id } }
      );
    }

    res.status(201).json(resp);
  } catch (err) {
    res.status(400).json({ erro: err.message });
  }
});

// Listar diretórios com preview das imagens
app.get("/diretorio", async (req, res) => {
  try {
    const dirs = await Diretorio.find().populate("listIMG");
    const dirsComPreview = dirs.map((d) => ({
      ...d.toObject(),
      listIMG: d.listIMG.map((img) => ({
        ...img.toObject(),
        previewPath: (() => {
          try {
            return getPreviewImagePath(img.nomeNaPasta);
          } catch {
            return "";
          }
        })(),
      })),
    }));
    res.status(200).json(dirsComPreview);
  } catch (err) {
    res.status(500).json({ erro: err.message });
  }
});

// Buscar diretório pelo ID
app.get("/diretorio/:id", async (req, res) => {
  try {
    const dir = await Diretorio.findById(req.params.id).populate("listIMG");
    if (!dir) return res.status(404).json({ erro: "Diretório não encontrado" });

    const dirComPreview = {
      ...dir.toObject(),
      listIMG: dir.listIMG.map((img) => ({
        ...img.toObject(),
        previewPath: (() => {
          try {
            return getPreviewImagePath(img.nomeNaPasta);
          } catch {
            return "";
          }
        })(),
      })),
    };

    res.status(200).json(dirComPreview);
  } catch (err) {
    res.status(500).json({ erro: err.message });
  }
});

// Atualizar diretório
app.put("/diretorio/:id", async (req, res) => {
  try {
    const { titulo, descricao, listIMG = [] } = req.body;
    const dir = await Diretorio.findById(req.params.id);
    if (!dir) return res.status(404).json({ erro: "Diretório não encontrado" });

    // Remove vínculo antigo
    await InfoImagem.updateMany(
      { _id: { $in: dir.listIMG } },
      { $pull: { diretorios: dir._id } }
    );

    dir.titulo = titulo;
    dir.descricao = descricao;
    dir.listIMG = listIMG;
    await dir.save();

    // Adiciona vínculo novo
    if (listIMG.length > 0) {
      await InfoImagem.updateMany(
        { _id: { $in: listIMG } },
        { $addToSet: { diretorios: dir._id } }
      );
    }

    res.status(200).json(dir);
  } catch (err) {
    res.status(500).json({ erro: err.message });
  }
});

// Deletar diretório
app.delete("/diretorio/:id", async (req, res) => {
  try {
    const dir = await Diretorio.findByIdAndDelete(req.params.id);
    if (!dir) return res.status(404).json({ erro: "Diretório não encontrado" });

    await InfoImagem.updateMany(
      { _id: { $in: dir.listIMG } },
      { $pull: { diretorios: dir._id } }
    );

    res.status(200).json({ message: "Diretório removido", item: dir });
  } catch (err) {
    res.status(500).json({ erro: err.message });
  }
});

/// ======================= ROTAS DE INFOIMAGEM =======================

// Criar imagem
app.post("/infoimagem", async (req, res) => {
  try {
    const { nomeNaPasta, nomeImagem, descricao, diretorios = [] } = req.body;
    const img = new InfoImagem({
      nomeNaPasta,
      nomeImagem,
      descricao,
      diretorios,
    });
    const resp = await img.save();

    if (diretorios.length > 0) {
      await Diretorio.updateMany(
        { _id: { $in: diretorios } },
        { $addToSet: { listIMG: resp._id } }
      );
    }

    res.status(201).json(resp);
  } catch (err) {
    res.status(400).json({ erro: err.message });
  }
});

// Listar todas as imagens
app.get("/infoimagem", async (req, res) => {
  try {
    const imgs = await InfoImagem.find().populate("diretorios");
    const imgsComPreview = imgs.map((img) => ({
      ...img.toObject(),
      previewPath: (() => {
        try {
          return getPreviewImagePath(img.nomeNaPasta);
        } catch {
          return "";
        }
      })(),
    }));
    res.status(200).json(imgsComPreview);
  } catch (err) {
    res.status(500).json({ erro: err.message });
  }
});

// Buscar imagem por ID
app.get("/infoimagem/:id", async (req, res) => {
  try {
    const img = await InfoImagem.findById(req.params.id).populate("diretorios");
    if (!img) return res.status(404).json({ erro: "Imagem não encontrada" });

    const imgComPreview = {
      ...img.toObject(),
      previewPath: (() => {
        try {
          return getPreviewImagePath(img.nomeNaPasta);
        } catch {
          return "";
        }
      })(),
    };

    res.status(200).json(imgComPreview);
  } catch (err) {
    res.status(500).json({ erro: err.message });
  }
});

// Atualizar imagem
app.put("/infoimagem/:id", async (req, res) => {
  try {
    const { nomeNaPasta, nomeImagem, descricao, diretorios = [] } = req.body;
    const img = await InfoImagem.findById(req.params.id);
    if (!img) return res.status(404).json({ erro: "Imagem não encontrada" });

    // Remove vínculo antigo
    await Diretorio.updateMany(
      { _id: { $in: img.diretorios } },
      { $pull: { listIMG: img._id } }
    );

    img.nomeNaPasta = nomeNaPasta;
    img.nomeImagem = nomeImagem;
    img.descricao = descricao;
    img.diretorios = diretorios;
    await img.save();

    // Adiciona vínculo novo
    if (diretorios.length > 0) {
      await Diretorio.updateMany(
        { _id: { $in: diretorios } },
        { $addToSet: { listIMG: img._id } }
      );
    }

    res.status(200).json(img);
  } catch (err) {
    res.status(500).json({ erro: err.message });
  }
});

// Deletar imagem
app.delete("/infoimagem/:id", async (req, res) => {
  try {
    const img = await InfoImagem.findByIdAndDelete(req.params.id);
    if (!img) return res.status(404).json({ erro: "Imagem não encontrada" });

    await Diretorio.updateMany(
      { _id: { $in: img.diretorios } },
      { $pull: { listIMG: img._id } }
    );

    res.status(200).json({ message: "Imagem removida", imagem: img });
  } catch (err) {
    res.status(500).json({ erro: err.message });
  }
});

// Middleware de erro genérico
app.use((err, req, res, next) => {
  console.error("Unhandled error:", err);
  res.status(err.status || 500).json({ erro: err.message || "Erro interno" });
});
