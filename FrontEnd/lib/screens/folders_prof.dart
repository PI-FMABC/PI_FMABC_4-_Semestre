import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'responsive.dart';

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

    Set<String> markedForRemoval = {};

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (context, setDialogState) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF2EDF7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                folder == null ? "Adicionar Tópico" : "Editar Tópico",
                style: const TextStyle(
                  color: Color(0xFF003b64),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 26),
              )
            ],
          ),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                
                  _buildStyledField(
                    controller: _tituloController,
                    label: "Título",
                  ),

                  const SizedBox(height: 12),

          
                  _buildStyledField(
                    controller: _descricaoController,
                    label: "Descrição",
                    maxLines: 4,
                  ),

                  const SizedBox(height: 12),

                
                  _buildStyledDropdown(
                    label: "Selecionar imagens",
                    value: null,
                    items: images.map((img) {
                      return DropdownMenuItem<String>(
                        value: img['_id'],
                        child: Text(img['nomeImagem'] ?? 'Sem nome'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null && !selectedImgs.contains(value)) {
                        setDialogState(() => selectedImgs.add(value));
                      }
                    },
                  ),

                  const SizedBox(height: 10),

               
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: selectedImgs.map((imgId) {
                      final imgName = images.firstWhere(
                              (img) => img['_id'] == imgId,
                              orElse: () => {
                                    'nomeImagem': 'Desconhecido'
                                  })['nomeImagem'] ??
                          'Desconhecido';

                      final isMarked = markedForRemoval.contains(imgId);

                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            if (isMarked) {
                              markedForRemoval.remove(imgId);
                            } else {
                              markedForRemoval.add(imgId);
                            }
                          });
                        },
                        child: Chip(
                          label: Text(imgName),
                          backgroundColor: isMarked ? Colors.red[100] : null,
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: isMarked ? Colors.red : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancelar",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF003b64),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009245),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final titulo = _tituloController.text.trim();
                final descricao = _descricaoController.text.trim();
                if (titulo.isEmpty || descricao.isEmpty) return;

                final finalImgs = selectedImgs
                    .where((id) => !markedForRemoval.contains(id))
                    .toList();

                await addOrEditFolder(
                  id: folder?['_id'],
                  titulo: titulo,
                  descricao: descricao,
                  imgs: finalImgs,
                );

                await fetchFolders();
                Navigator.pop(context);
              },
              child: Text(folder == null ? "Adicionar" : "Salvar"),
            ),
          ],
        );
      }),
    );
  }


  Widget _buildStyledField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: Color(0xFF003b64)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF003b64)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF003b64), width: 2),
        ),
      ),
    );
  }


  Widget _buildStyledDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: Color(0xFF003b64)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF003b64)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF003b64), width: 2),
        ),
      ),
    );
  }

  void _navigateToRoute(BuildContext context, String routeName) {
    debugPrint('=== TENTANDO NAVEGAR ===');
    debugPrint('Rota atual: ${ModalRoute.of(context)?.settings.name}');
    debugPrint('Rota destino: $routeName');

    if (ModalRoute.of(context)?.settings.name != routeName) {
      debugPrint('✅ Navegando para: $routeName');
      Navigator.pushNamed(context, routeName);
    } else {
      debugPrint('❌ Já está na rota: $routeName');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

   
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Responsive.isMobile(context) ? 70 : 80),
        child: Container(
          color: const Color(0xFF003b64),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: Responsive.isMobile(context) ? 12 : 20),
                child: Row(
                  children: [
                 
                    if (Responsive.isMobile(context) ||
                        Responsive.isTablet(context))
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                    Image.asset(
                      'lib/assets/logo.png',
                      height: Responsive.isMobile(context) ? 45 : 55,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                    SizedBox(width: Responsive.isMobile(context) ? 6 : 10),
                    Responsive.isMobile(context)
                        ? const Text(
                            "Atlas",
                            style: TextStyle(
                              color: Color(0xFF009245),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Text(
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

             
              if (Responsive.isDesktop(context))
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green[600],
                          content: const Text(
                            'Logout realizado com sucesso!',
                            style: TextStyle(fontSize: 16),
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
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

 
      drawer: (Responsive.isMobile(context) || Responsive.isTablet(context))
          ? _buildDrawer(context)
          : null,

      body: Padding(
        padding: EdgeInsets.all(Responsive.isMobile(context) ? 16.0 : 20.0),
        child: Column(
          children: [
         
            if (Responsive.isDesktop(context))
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFe5e5e5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMenuButton(context, "Home",
                          onTap: () => _navigateToRoute(context, '/prof')),
                      _buildMenuButton(context, "Tópicos", isActive: true),
                      _buildMenuButton(context, "Galeria",
                          onTap: () =>
                              _navigateToRoute(context, '/gallery_prof')),
                    ],
                  ),
                ),
              ),

            if (Responsive.isDesktop(context)) const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showFolderDialog(context),
                  icon: const Icon(Icons.add),
                  label: Text(
                    "Adicionar Tópico",
                    style: TextStyle(
                      fontSize: Responsive.isMobile(context) ? 14 : 16,
                    ),
                  ),
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Responsive.isMobile(context) ? 2 : 3,
                        crossAxisSpacing:
                            Responsive.isMobile(context) ? 12 : 16,
                        mainAxisSpacing: Responsive.isMobile(context) ? 12 : 16,
                        childAspectRatio:
                            Responsive.isMobile(context) ? 0.8 : 0.9,
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
                            onTap: () {}, // Adicione ação se necessário
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
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: Responsive.isMobile(context)
                                              ? 14
                                              : 16,
                                          color: const Color(0xFF003b64),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        descricao,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: Responsive.isMobile(context)
                                              ? 12
                                              : 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 10),
                                      if (listIMG.isNotEmpty)
                                        SizedBox(
                                          height: Responsive.isMobile(context)
                                              ? 80
                                              : 100,
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
                                                child: GestureDetector(
                                                  onTap: () {
                                                    List<String> parts = previewPath.split('/');
                                                    final filename = parts.first;
                                                    
                                                    Navigator.pushNamed(
                                                      context, 
                                                      '/image-viewer',
                                                      arguments: {
                                                        'imageFilename': filename
                                                      }
                                                    );
                                                  },
                                                  child: Container(
                                                    width: Responsive.isMobile(
                                                            context)
                                                        ? 70
                                                        : 80,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 1.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: AspectRatio(
                                                        aspectRatio: 1,
                                                        child: previewPath
                                                                .isNotEmpty
                                                            ? Image.network(
                                                                "http://localhost:3000/tiles/$previewPath",
                                                                fit: BoxFit
                                                                    .cover,
                                                                errorBuilder: (_,
                                                                        __,
                                                                        ___) =>
                                                                    const Icon(
                                                                  Icons
                                                                      .broken_image,
                                                                  size: 30,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              )
                                                            : const Icon(
                                                                Icons
                                                                    .broken_image,
                                                                size: 30,
                                                                color:
                                                                    Colors.grey,
                                                              ),
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
                                        icon: Icon(Icons.edit,
                                            color: const Color(0xFF003b64),
                                            size: Responsive.isMobile(context)
                                                ? 18
                                                : 24),
                                        tooltip: "Editar Tópico",
                                        onPressed: () => _showFolderDialog(
                                            context,
                                            folder: folder),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.redAccent,
                                            size: Responsive.isMobile(context)
                                                ? 18
                                                : 24),
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

 
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF003b64),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Atlas de Histologia',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Modo Professor',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home Professor'),
            onTap: () {
              Navigator.pop(context);
              _navigateToRoute(context, '/prof');
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text('Gerenciar Diretórios'),
            onTap: () {
              Navigator.pop(context);
              _navigateToRoute(context, '/folders_prof');
            },
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Gerenciar Galeria'),
            onTap: () {
              Navigator.pop(context);
              _navigateToRoute(context, '/gallery_prof');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green[600],
                  content: const Text(
                    'Logout realizado com sucesso!',
                    style: TextStyle(fontSize: 16),
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String label,
      {bool isActive = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            debugPrint('=== BOTÃO $label CLICADO ===');
            if (onTap == null) {
              debugPrint('❌ onTap é NULL para: $label');
            } else {
              debugPrint('✅ onTap disponível para: $label');
              onTap();
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF003b64) : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
