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
  List<dynamic> images = [];

  @override
  void initState() {
    super.initState();
    fetchFolders();
    fetchImages();
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

  Future<void> fetchImages() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/infoimagem'));
      if (response.statusCode == 200) {
        setState(() {
          images = json.decode(response.body);
        });
      } else {
        throw Exception('Erro ao carregar imagens: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao buscar imagens: $e');
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

  Future<void> addOrEditFolder({
    String? id,
    required String titulo,
    required String descricao,
    required List<String> imgs,
  }) async {
    final uri = id == null
        ? Uri.parse('http://localhost:3000/diretorio')
        : Uri.parse('http://localhost:3000/diretorio/$id');
    final method = id == null ? 'POST' : 'PUT';

    final response = await (method == 'POST'
        ? http.post(uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'titulo': titulo,
              'descricao': descricao,
              'listIMG': imgs,
            }))
        : http.put(uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'titulo': titulo,
              'descricao': descricao,
              'listIMG': imgs,
            })));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          'Erro ao ${id == null ? "adicionar" : "editar"} pasta: ${response.statusCode}');
    }
  }

  void _showFolderDialog(BuildContext context, {Map<String, dynamic>? folder}) {
    final _tituloController =
        TextEditingController(text: folder != null ? folder['titulo'] : '');
    final _descricaoController =
        TextEditingController(text: folder != null ? folder['descricao'] : '');
    List<String> selectedImgs = folder != null && folder['listIMG'] != null
        ? (folder['listIMG'] as List)
            .map<String>((img) => img['_id'] ?? img.toString())
            .toList()
        : [];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(folder == null ? "Adicionar Tópico" : "Editar Tópico"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: "Título"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: "Descrição"),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedImgs.isNotEmpty ? selectedImgs.first : null,
                items: images
                    .map((img) => DropdownMenuItem<String>(
                          value: img['_id'],
                          child: Text(img['nomeImagem'] ?? 'Sem nome'),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      if (!selectedImgs.contains(value))
                        selectedImgs.add(value);
                    });
                  }
                },
                decoration: const InputDecoration(
                    labelText: "Selecionar imagens (click para adicionar)"),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                children: selectedImgs
                    .map((imgId) => Chip(
                          label: Text(
                            images.firstWhere((i) => i['_id'] == imgId,
                                    orElse: () => {
                                          'nomeImagem': 'Desconhecido'
                                        })['nomeImagem'] ??
                                'Desconhecido',
                          ),
                          onDeleted: () {
                            setState(() {
                              selectedImgs.remove(imgId);
                            });
                          },
                        ))
                    .toList(),
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
              if (titulo.isEmpty || descricao.isEmpty) return;

              await addOrEditFolder(
                id: folder?['_id'],
                titulo: titulo,
                descricao: descricao,
                imgs: selectedImgs,
              );
              await fetchFolders();
              Navigator.pop(context);
            },
            child: Text(folder == null ? "Adicionar" : "Salvar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: const Color(0xFF003b64),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Image.asset(
                      'lib/assets/logo.png',
                      height: 55,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Atlas de Histologia",
                      style: TextStyle(
                        color: Color(0xFF009245),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF003b64),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text("Sair"),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showFolderDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text("Adicionar Tópico"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003b64),
                    foregroundColor: Colors.white,
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
                        final id = folder['_id'] ?? '';
                        final titulo = folder['titulo'] ?? 'Sem título';
                        final descricao =
                            folder['descricao'] ?? 'Sem descrição';
                        final listIMG = (folder['listIMG'] ?? []) as List;

                        return Card(
                          color: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
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
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        descricao,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 10),
                                      if (listIMG.isNotEmpty)
                                        SizedBox(
                                          height: 100,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children:
                                                listIMG.map<Widget>((img) {
                                              String previewPath = '';
                                              if (img is Map &&
                                                  img['previewPath'] != null) {
                                                previewPath =
                                                    img['previewPath'];
                                              }
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: AspectRatio(
                                                    aspectRatio: 1,
                                                    child: previewPath
                                                            .isNotEmpty
                                                        ? Image.network(
                                                            "http://localhost:3000/tiles/$previewPath",
                                                            fit: BoxFit.cover,
                                                            errorBuilder:
                                                                (_, __, ___) =>
                                                                    const Icon(
                                                              Icons
                                                                  .broken_image,
                                                              size: 50,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          )
                                                        : const Icon(
                                                            Icons.broken_image,
                                                            size: 50,
                                                            color: Colors.grey,
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
                                        onPressed: () => _showFolderDialog(
                                            context,
                                            folder: folder),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.redAccent),
                                        tooltip: "Excluir pasta",
                                        onPressed: () async {
                                          final confirm =
                                              await showDialog<bool>(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title:
                                                  const Text("Excluir pasta"),
                                              content: Text(
                                                  "Tem certeza que deseja excluir '$titulo'?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, false),
                                                  child: const Text("Cancelar"),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.redAccent),
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, true),
                                                  child: const Text("Excluir"),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (confirm == true) {
                                            await deleteFolder(id);
                                          }
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
    );
  }
}
