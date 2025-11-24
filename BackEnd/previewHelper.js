const fs = require("fs");
const path = require("path");


function getPreviewImagePath(nomeNaPasta) {
  const tilesDir = path.join(__dirname, "../Tiles"); 
  const pasta = path.join(tilesDir, nomeNaPasta);
  if (!fs.existsSync(pasta)) {
    throw new Error(`Pasta '${nomeNaPasta}' não encontrada em Tiles`);
  }
  const levels = fs
    .readdirSync(pasta, { withFileTypes: true })
    .filter((dirent) => dirent.isDirectory() && dirent.name.startsWith("level"))
    .map((dirent) => dirent.name);

  if (levels.length === 0) {
    throw new Error(`Nenhum level encontrado na pasta '${nomeNaPasta}'`);
  }

  const maxLevel = levels.reduce((prev, curr) => {
    const prevNum = parseInt(prev.replace("level", ""), 10);
    const currNum = parseInt(curr.replace("level", ""), 10);
    return currNum > prevNum ? curr : prev;
  });

  
  const relativePath = `${nomeNaPasta}/${maxLevel}/0_0_HQ.jpg`;

  return relativePath; 
}

module.exports = { getPreviewImagePath };
