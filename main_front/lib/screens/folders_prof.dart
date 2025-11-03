import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoldersProfScreen extends StatefulWidget {
  const FoldersProfScreen({super.key});

  @override
  State<FoldersProfScreen> createState() => _FoldersProfScreenState();
}

class _FoldersProfScreenState extends State<FoldersProfScreen> {
  List<dynamic> folders = [];

  @override
  void initState() {
    super.initState();
    fetchFolders();
  }

  Future<void> fetchFolders() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/diretorio'));
      if (response.statusCode == 200) {
        setState(() {
          folders = json.decode(response.body);
        });
      } else {
        throw Exception('Erro ao carregar pastas: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao buscar pastas: $e');
    }
  }

  Future<void> deleteFolder(String id) async {
    try {
      final response =
          await http.delete(Uri.parse('http://localhost:3000/diretorio/$id'));
      if (response.statusCode == 200) {
        setState(() {
          folders.removeWhere((folder) => folder['_id'] == id);
        });
      } else {
        debugPrint('Erro ao excluir pasta: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao excluir pasta: $e');
    }
  }

  Future<void> _addTopicToDB(
      String titulo, String descricao, String img) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/diretorio'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'titulo': titulo,
          'descricao': descricao,
          'listIMG': [img],
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          folders.add(json.decode(response.body));
        });
      } else {
        debugPrint('Erro ao adicionar tópico: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao adicionar tópico: $e');
    }
  }

  Future<void> _editTopicInDB(
      String id, String titulo, String descricao, String img) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/diretorio/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'titulo': titulo,
          'descricao': descricao,
          'listIMG': [img],
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          final index = folders.indexWhere((folder) => folder['_id'] == id);
          if (index != -1) {
            folders[index] = json.decode(response.body);
          }
        });
      } else {
        debugPrint('Erro ao editar tópico: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao editar tópico: $e');
    }
  }

  void _showAddTopicDialog() {
    final _tituloController = TextEditingController();
    final _descricaoController = TextEditingController();
    final _imgController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Adicionar Tópico"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: "Título"),
              ),
              TextField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: "Descrição"),
              ),
              TextField(
                controller: _imgController,
                decoration: const InputDecoration(labelText: "Link da imagem"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              final titulo = _tituloController.text.trim();
              final descricao = _descricaoController.text.trim();
              final img = _imgController.text.trim();

              if (titulo.isEmpty || descricao.isEmpty || img.isEmpty) return;

              await _addTopicToDB(titulo, descricao, img);
              Navigator.pop(context);
            },
            child: const Text("Adicionar"),
          ),
        ],
      ),
    );
  }

  void _showEditTopicDialog(Map<String, dynamic> folder) {
    final _tituloController =
        TextEditingController(text: folder['titulo'] ?? '');
    final _descricaoController =
        TextEditingController(text: folder['descricao'] ?? '');
    final _imgController = TextEditingController(
        text: (folder['listIMG'] != null && folder['listIMG'].isNotEmpty)
            ? folder['listIMG'][0]
            : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar Tópico"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: "Título"),
              ),
              TextField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: "Descrição"),
              ),
              TextField(
                controller: _imgController,
                decoration: const InputDecoration(labelText: "Link da imagem"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              final titulo = _tituloController.text.trim();
              final descricao = _descricaoController.text.trim();
              final img = _imgController.text.trim();

              if (titulo.isEmpty || descricao.isEmpty || img.isEmpty) return;

              await _editTopicInDB(folder['_id'], titulo, descricao, img);
              Navigator.pop(context);
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF003b64),
        title: const Text(
          "Atlas de Citologia - Modo Professor",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton.icon(
              onPressed: () => Navigator.pushReplacementNamed(context, '/'),
              icon: const Icon(Icons.logout, color: Color(0xFF003b64)),
              label: const Text(
                "Sair",
                style: TextStyle(
                  color: Color(0xFF003b64),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Container()), // mantém o layout sem o texto
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _showAddTopicDialog,
                  icon: const Icon(Icons.add),
                  label: const Text("Adicionar Tópico"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003b64),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: folders.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF003b64),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: folders.length,
                      itemBuilder: (context, index) {
                        final folder = folders[index];
                        final String id = folder['_id'] ?? '';
                        final String titulo = folder['titulo'] ?? 'Sem título';
                        final String descricao =
                            folder['descricao'] ?? 'Sem descrição';
                        final List listIMG =
                            (folder['listIMG'] ?? []) as List<dynamic>;

                        return Card(
                          color: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () =>
                                Navigator.pushNamed(context, '/index_prof'),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        titulo,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xFF003b64),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        descricao,
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                            height: 1.3),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 10),
                                      if (listIMG.isNotEmpty)
                                        SizedBox(
                                          height: 100,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: listIMG
                                                .take(3)
                                                .map<Widget>((img) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: AspectRatio(
                                                    aspectRatio: 1,
                                                    child: Image.network(
                                                      img,
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (_, __, ___) =>
                                                              const Icon(
                                                        Icons.broken_image,
                                                        size: 50,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        )
                                      else
                                        const Expanded(
                                          child: Center(
                                            child: Icon(
                                              Icons.folder,
                                              size: 60,
                                              color: Color(0xFF003b64),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 4,
                                  top: 4,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Color(0xFF003b64)),
                                        tooltip: "Editar Tópico",
                                        onPressed: () =>
                                            _showEditTopicDialog(folder),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.redAccent),
                                        tooltip: "Excluir pasta",
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title:
                                                  const Text("Excluir pasta"),
                                              content: Text(
                                                  "Tem certeza que deseja excluir '$titulo'?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text("Cancelar"),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    deleteFolder(id);
                                                  },
                                                  child: const Text("Excluir"),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color(0xFF003b64),
        unselectedItemColor: Colors.grey[600],
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/prof');
          if (i == 1) Navigator.pushReplacementNamed(context, '/folders_prof');
          if (i == 2) Navigator.pushReplacementNamed(context, '/index_prof');
          if (i == 3) Navigator.pushReplacementNamed(context, '/gallery_prof');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: "Pastas"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Índice"),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: "Galeria"),
        ],
      ),
    );
  }
}
