import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GalleryProfScreen extends StatefulWidget {
  const GalleryProfScreen({super.key});

  @override
  State<GalleryProfScreen> createState() => _GalleryProfScreenState();
}

class _GalleryProfScreenState extends State<GalleryProfScreen> {
  List<dynamic> imagens = [];
  List<dynamic> folders = [];

  @override
  void initState() {
    super.initState();
    fetchImagens();
    fetchFolders();
  }

  Future<void> fetchImagens() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/infoimagem'));
      if (response.statusCode == 200) {
        setState(() {
          imagens = json.decode(response.body);
        });
      } else {
        throw Exception('Erro ao carregar imagens: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao buscar imagens: $e');
    }
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
        debugPrint('Erro ao carregar pastas: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao buscar pastas: $e');
    }
  }

  Future<void> deleteImagem(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Excluir imagem"),
        content: const Text("Tem certeza que deseja excluir esta imagem?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancelar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Excluir"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final response =
          await http.delete(Uri.parse('http://localhost:3000/infoimagem/$id'));
      if (response.statusCode == 200) {
        setState(() {
          imagens.removeWhere((img) => img['_id'] == id);
        });
      } else {
        debugPrint('Erro ao excluir imagem: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao excluir imagem: $e');
    }
  }

  Future<void> _addImagemToDB({
    required String nomeNaPasta,
    required String nomeImagem,
    required String descricao,
    required String folderId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/infoimagem'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nomeNaPasta': nomeNaPasta,
          'nomeImagem': nomeImagem,
          'descricao': descricao,
          'diretorios': [folderId],
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          imagens.add(json.decode(response.body));
        });
      } else {
        debugPrint('Erro ao adicionar imagem: ${response.body}');
      }
    } catch (e) {
      debugPrint('Erro ao adicionar imagem: $e');
    }
  }

  void _showAddImagemDialog() {
    final _nomeNaPastaController = TextEditingController();
    final _nomeImagemController = TextEditingController();
    final _descricaoController = TextEditingController();
    String? selectedFolderId;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Adicionar Imagem"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeNaPastaController,
                decoration: const InputDecoration(labelText: "Nome da pasta"),
              ),
              TextField(
                controller: _nomeImagemController,
                decoration: const InputDecoration(labelText: "Nome da imagem"),
              ),
              TextField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: "Descrição"),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedFolderId,
                decoration: const InputDecoration(
                  labelText: "Vincular a um Tópico",
                ),
                items: folders.map<DropdownMenuItem<String>>((folder) {
                  return DropdownMenuItem<String>(
                    value: folder['_id'],
                    child: Text(folder['titulo'] ?? 'Sem título'),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedFolderId = value;
                },
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
              final nomeNaPasta = _nomeNaPastaController.text.trim();
              final nomeImagem = _nomeImagemController.text.trim();
              final descricao = _descricaoController.text.trim();

              if (nomeNaPasta.isEmpty ||
                  nomeImagem.isEmpty ||
                  descricao.isEmpty ||
                  selectedFolderId == null) return;

              await _addImagemToDB(
                nomeNaPasta: nomeNaPasta,
                nomeImagem: nomeImagem,
                descricao: descricao,
                folderId: selectedFolderId!,
              );

              Navigator.pop(context);
              await fetchImagens();
              await fetchFolders();
            },
            child: const Text("Adicionar"),
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
                  onPressed: _showAddImagemDialog,
                  icon: const Icon(Icons.add),
                  label: const Text("Adicionar Imagem"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003b64),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: imagens.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF003b64),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemCount: imagens.length,
                      itemBuilder: (context, index) {
                        final img = imagens[index];
                        final titulo = img['nomeImagem'] ?? 'Sem título';
                        final descricao = img['descricao'] ?? '';
                        final id = img['_id'] ?? '';
                        final previewPath = img['previewPath'] ?? '';

                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: previewPath.isNotEmpty
                                        ? Image.network(
                                            'http://localhost:3000/tiles/$previewPath',
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(
                                              Icons.broken_image,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                          )
                                        : const Center(
                                            child: Icon(
                                              Icons.folder,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          titulo,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          descricao,
                                          style: const TextStyle(fontSize: 12),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                right: 4,
                                top: 4,
                                child: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  tooltip: "Excluir imagem",
                                  onPressed: () => deleteImagem(id),
                                ),
                              ),
                            ],
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
