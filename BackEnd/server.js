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

//rotas:
const Diretorio = require("./diretorioSchema");
const InfoImagem = require("./infoImagemSchema");


app.use(express.json());
app.use(cors());

const PORT = process.env.PORT || 3000;

// Conexão com o MongoDB e inicializa servidor somente após conectar
async function start() {
  try {
    await mongoose.connect(process.env.MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log(" Conectado ao MongoDB");

    app.listen(PORT, () =>
      console.log(` Servidor rodando em http://localhost:${PORT}`)
    );
  } catch (err) {
    console.error(" MongoDB erro de conexão:", err);
    process.exit(1); // encerra para evitar comportamento inconsistente
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

// Parte de Diretorio:
// Criar novo item
app.post("/diretorio", async (req, res) => {
  try {
    console.log(" Tentando criar item no diretório...");
    const item = new Diretorio(req.body);
    const respMongo = await item.save();
    console.log(" Item criado com sucesso:", respMongo);
    res.status(201).json(respMongo);
  } catch (erro) {
    console.log(" Erro ao criar item:", erro.message);
    res.status(400).json({ erro: erro.message });
  }
});

// Listar todos os itens
app.get("/diretorio", async (req, res) => {
  try {
    const itens = await Diretorio.find();
    res.status(200).json(itens);
  } catch (erro) {
    console.log("Erro ao listar itens:", erro.message);
    res.status(500).json({ erro: erro.message });
  }
});

// Buscar item pelo ID
app.get("/diretorio/:id", async (req, res) => {
  try {
    const item = await Diretorio.findById(req.params.id);
    if (!item) return res.status(404).json({ erro: "Item não encontrado" });
    res.status(200).json(item);
  } catch (erro) {
    console.log("Erro ao buscar item:", erro.message);
    res.status(500).json({ erro: erro.message });
  }
});

//  Remover item pelo ID
app.delete("/diretorio/:id", async (req, res) => {
  try {
    const item = await Diretorio.findByIdAndDelete(req.params.id);
    if (!item)
      return res
        .status(404)
        .json({ erro: "Item não encontrado para exclusão" });

    console.log("Item removido com sucesso:", item._id);
    res.status(200).json({
      message: "Item removido com sucesso",
      item,
    });
  } catch (erro) {
    console.log("Erro ao remover item:", erro.message);
    res.status(500).json({ erro: erro.message });
  }
});

// Atualizar item pelo ID
app.put("/diretorio/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const updatedItem = await Diretorio.findByIdAndUpdate(
      id,
      {
        titulo: req.body.titulo,
        descricao: req.body.descricao,
        listIMG: req.body.listIMG,
      },
      { new: true, runValidators: true } // retorna o item atualizado e executa validações
    );

    if (!updatedItem) {
      return res.status(404).json({ erro: "Item não encontrado para edição" });
    }

    console.log("Item atualizado com sucesso:", updatedItem._id);
    res.status(200).json(updatedItem);
  } catch (erro) {
    console.log("Erro ao editar item:", erro.message);
    res.status(500).json({ erro: erro.message });
  }
});

//Parte das Imagens
// ==================== PARTE DE INFOIMAGEM ====================
// Criar nova imagem
app.post("/infoimagem", async (req, res) => {
  try {
    console.log("Tentando criar registro de imagem...");
    const imagem = new InfoImagem(req.body);
    const respMongo = await imagem.save();
    console.log("Imagem criada com sucesso:", respMongo);
    res.status(201).json(respMongo);
  } catch (erro) {
    console.log("Erro ao criar imagem:", erro.message);
    res.status(400).json({ erro: erro.message });
  }
});

// Listar todas as imagens
// Listar todas as imagens com preview
app.get("/infoimagem", async (req, res) => {
  try {
    const imagens = await InfoImagem.find();

    const imagensComPreview = imagens.map((img) => {
      let previewPath = "";
      try {
        previewPath = getPreviewImagePath(img.nomeNaPasta);
      } catch (err) {
        console.error(err.message);
      }
      return {
        ...img.toObject(),
        previewPath, // caminho relativo ou absoluto da imagem preview
      };
    });

    res.status(200).json(imagensComPreview);
  } catch (erro) {
    console.log("Erro ao listar imagens:", erro.message);
    res.status(500).json({ erro: erro.message });
  }
});

// Buscar imagem pelo ID
app.get("/infoimagem/:id", async (req, res) => {
  try {
    const imagem = await InfoImagem.findById(req.params.id);
    if (!imagem) return res.status(404).json({ erro: "Imagem não encontrada" });
    res.status(200).json(imagem);
  } catch (erro) {
    console.log("Erro ao buscar imagem:", erro.message);
    res.status(500).json({ erro: erro.message });
  }
});

// Atualizar imagem pelo ID
app.put("/infoimagem/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const updatedImagem = await InfoImagem.findByIdAndUpdate(
      id,
      {
        nomeNaPasta: req.body.nomeNaPasta,
        nomeImagem: req.body.nomeImagem,
        descricao: req.body.descricao,
      },
      { new: true, runValidators: true }
    );

    if (!updatedImagem) {
      return res
        .status(404)
        .json({ erro: "Imagem não encontrada para edição" });
    }

    console.log("Imagem atualizada com sucesso:", updatedImagem._id);
    res.status(200).json(updatedImagem);
  } catch (erro) {
    console.log("Erro ao editar imagem:", erro.message);
    res.status(500).json({ erro: erro.message });
  }
});

// Remover imagem pelo ID
app.delete("/infoimagem/:id", async (req, res) => {
  try {
    const imagem = await InfoImagem.findByIdAndDelete(req.params.id);
    if (!imagem)
      return res
        .status(404)
        .json({ erro: "Imagem não encontrada para exclusão" });

    console.log("Imagem removida com sucesso:", imagem._id);
    res.status(200).json({
      message: "Imagem removida com sucesso",
      imagem,
    });
  } catch (erro) {
    console.log("Erro ao remover imagem:", erro.message);
    res.status(500).json({ erro: erro.message });
  }
});

// middleware de erro genérico
app.use((err, req, res, next) => {
  console.error("Unhandled error:", err);
  res.status(err.status || 500).json({ erro: err.message || "Erro interno" });
});
