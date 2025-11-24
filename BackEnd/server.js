const express = require("express");
const mongoose = require("mongoose");
const sql = require("mysql2");
const bcrypt = require("bcrypt");
const cors = require("cors");
const path = require("path");
require("dotenv").config();

const { getPreviewImagePath } = require("./previewHelper"); 


const Diretorio = require("./diretorioSchema");
const InfoImagem = require("./infoImagemSchema");


const sqlDB = sql.createConnection({
  host: process.env.HOST,
  port: process.env.SQL_PORT,
  user:process.env.USER,
  password: process.env.PASS,
  database: process.env.DBNAME
});

const app = express();
app.use(express.json());
app.use(cors());


app.use("/tiles", express.static(path.join(__dirname, "../Tiles")));

const PORT = process.env.PORT || 3000;


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


app.put("/diretorio/:id", async (req, res) => {
  try {
    const { titulo, descricao, listIMG = [] } = req.body;
    const dir = await Diretorio.findById(req.params.id);
    if (!dir) return res.status(404).json({ erro: "Diretório não encontrado" });


    await InfoImagem.updateMany(
      { _id: { $in: dir.listIMG } },
      { $pull: { diretorios: dir._id } }
    );

    dir.titulo = titulo;
    dir.descricao = descricao;
    dir.listIMG = listIMG;
    await dir.save();


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


app.put("/infoimagem/:id", async (req, res) => {
  try {
    const { nomeNaPasta, nomeImagem, descricao, diretorios = [] } = req.body;
    const img = await InfoImagem.findById(req.params.id);
    if (!img) return res.status(404).json({ erro: "Imagem não encontrada" });

    
    await Diretorio.updateMany(
      { _id: { $in: img.diretorios } },
      { $pull: { listIMG: img._id } }
    );

    img.nomeNaPasta = nomeNaPasta;
    img.nomeImagem = nomeImagem;
    img.descricao = descricao;
    img.diretorios = diretorios;
    await img.save();


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



app.get("/professores", async (req, res) => {
  sqlDB.query("SELECT * FROM professores", (err, results) => {
    if (err) return res.status(err.status || 500).json({erro: err.message || "Erro interno"});
    res.json(results);
  });
});


app.delete("/professores/:email", async (req, res) => {
  sqlDB.query("DELETE FROM professores WHERE email = ?", [req.params.email], (err) => {
    if (err) return res.status(err.status || 500).json({erro: err.message || "Erro interno"});
    res.status(200).json({
      message: "Professor removido com sucesso"
    });
  });
});


app.post("/professores", async (req, res) => {
  const hash_senha = await bcrypt.hash(req.body.senha, 12);
  sqlDB.query("INSERT INTO professores (email, senha, nome) VALUES (?, ?, ?)", [req.body.email, hash_senha, req.body.nome], (err) => {
    if (err) return res.status(err.status || 500).json({erro: err.message || "Erro interno"});
    res.status(200).json({
      message: "Professor adicionado com sucesso"
    });
  });
});


app.put("/professores", async (req, res) => {
  const hash_senha = await bcrypt.hash(req.body.senha, 12);
  sqlDB.query("UPDATE professores SET email=?, senha=?, nome=? WHERE email=?", [req.body.email, hash_senha, req.body.nome, req.body.oldEmail], (err) => {
    if (err) return res.status(err.status || 500).json({erro: err.message || "Erro interno"});
    res.status(200).json({
      message: "Professor modificado com sucesso"
    });
  });
});


app.post("/professores/login", async (req, res) => {
  sqlDB.query("SELECT email, senha FROM professores WHERE email=?", [req.body.email], async (err, results) => {
    if (err) return res.status(err.status || 500).json({erro: err.message || "Erro interno"});
    let resultEmail;
    let resultSenha;
    let senhaIgual
    if (results.length > 0) {
      resultEmail = results[0]['email'];
      resultSenha = results[0]['senha'];
      senhaIgual = bcrypt.compareSync(req.body.senha, resultSenha, (err, result) => {
        if (err) {
          return
        }
        if (result) {
          return result;
        }
      });
    }
    if (req.body.email == resultEmail && senhaIgual) {
      res.status(200).json({
        message: "Login de professor validado"
    });
    }
    else {
      res.status(500).json({
        message: "Login de professor inválido"
      });
    }
  });
})



app.post("/admin/login", async (req, res) => {
  sqlDB.query("SELECT email, senha FROM admin WHERE email=?", [req.body.email], async (err, results) => {
    if (err) return res.status(err.status || 500).json({erro: err.message || "Erro interno"});
    let resultEmail;
    let resultSenha;
    let senhaIgual
    if (results.length > 0) {
      resultEmail = results[0]['email'];
      resultSenha = results[0]['senha'];
      senhaIgual = bcrypt.compareSync(req.body.senha, resultSenha, (err, result) => {
        if (err) {
          return
        }
        if (result) {
          return result;
        }
      });
    }   
    if (req.body.email === resultEmail && senhaIgual) {
      res.status(200).json({
        message: "Login de Admin validado"
    });;
    }
    else {
      res.status(500).json({
        message: "Login de Admin inválido"
    });
    }
  });
})


app.use((err, req, res, next) => {
  console.error("Unhandled error:", err);
  res.status(err.status || 500).json({ erro: err.message || "Erro interno" });
});
