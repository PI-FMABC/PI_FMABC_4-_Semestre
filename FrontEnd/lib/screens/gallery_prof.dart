import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'responsive.dart';

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

  Future<void> addOrEditImagem({
    String? id,
    required String nomeNaPasta,
    required String nomeImagem,
    required String descricao,
    required List<String> listFolders,
  }) async {
    final uri = id == null
        ? Uri.parse('http://localhost:3000/infoimagem')
        : Uri.parse('http://localhost:3000/infoimagem/$id');
    final method = id == null ? 'POST' : 'PUT';

    final response = await (method == 'POST'
        ? http.post(uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'nomeNaPasta': nomeNaPasta,
              'nomeImagem': nomeImagem,
              'descricao': descricao,
              'diretorios': listFolders,
            }))
        : http.put(uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'nomeNaPasta': nomeNaPasta,
              'nomeImagem': nomeImagem,
              'descricao': descricao,
              'diretorios': listFolders,
            })));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          'Erro ao ${id == null ? "adicionar" : "editar"} imagem: ${response.statusCode}');
    }
  }

  void _showImagemDialog(BuildContext context, {Map<String, dynamic>? img}) {
    final _nomeNaPastaController =
        TextEditingController(text: img?['nomeNaPasta'] ?? '');
    final _nomeImagemController =
        TextEditingController(text: img?['nomeImagem'] ?? '');
    final _descricaoController =
        TextEditingController(text: img?['descricao'] ?? '');
    List<String> selectedFolders = img?['diretorios'] != null
        ? (img!['diretorios'] as List)
            .map<String>((f) => f is Map ? f['_id'] as String : f.toString())
            .toList()
        : [];

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (context, setDialogState) {
        return AlertDialog(
          title: Text(img == null ? "Adicionar Imagem" : "Editar Imagem"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nomeNaPastaController,
                  decoration: const InputDecoration(labelText: "Nome da pasta"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nomeImagemController,
                  decoration:
                      const InputDecoration(labelText: "Nome da imagem"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(labelText: "Descrição"),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: null,
                  decoration:
                      const InputDecoration(labelText: "Adicionar pasta"),
                  items: folders.map((folder) {
                    return DropdownMenuItem<String>(
                      value: folder['_id'],
                      child: Text(folder['titulo'] ?? 'Sem título'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null && !selectedFolders.contains(value)) {
                      setDialogState(() {
                        selectedFolders.add(value);
                      });
                    }
                  },
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: selectedFolders.map((folderId) {
                    final folderName = folders.firstWhere(
                            (f) => f['_id'] == folderId,
                            orElse: () =>
                                {'titulo': 'Desconhecido'})['titulo'] ??
                        'Desconhecido';
                    return Chip(
                      label: Text(folderName),
                      onDeleted: () {
                        setDialogState(() {
                          selectedFolders.remove(folderId);
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar")),
            ElevatedButton(
              onPressed: () async {
                final nomeNaPasta = _nomeNaPastaController.text.trim();
                final nomeImagem = _nomeImagemController.text.trim();
                final descricao = _descricaoController.text.trim();
                if (nomeNaPasta.isEmpty ||
                    nomeImagem.isEmpty ||
                    descricao.isEmpty) return;

                await addOrEditImagem(
                  id: img?['_id'],
                  nomeNaPasta: nomeNaPasta,
                  nomeImagem: nomeImagem,
                  descricao: descricao,
                  listFolders: selectedFolders,
                );
                await fetchImagens();
                Navigator.pop(context);
              },
              child: Text(img == null ? "Adicionar" : "Salvar"),
            ),
          ],
        );
      }),
    );
  }

  void _navigateToRoute(BuildContext context, String routeName) {
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushNamed(context, routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      /// ===========================
      /// NAVBAR SUPERIOR - RESPONSIVA
      /// ===========================
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Responsive.isMobile(context) ? 70 : 80),
        child: Container(
          color: const Color(0xFF003b64),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: Responsive.isMobile(context) ? 12 : 20),
                child: Row(
                  children: [
                    // BOTÃO MENU HAMBURGUER PARA MOBILE/TABLET
                    if (Responsive.isMobile(context) || Responsive.isTablet(context))
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
              
              // BOTÃO SAIR APENAS NO DESKTOP (MOBILE FICA NO DRAWER)
              if (Responsive.isDesktop(context))
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context, 
                        '/', 
                        (route) => false
                      );
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

      /// ===========================
      /// DRAWER PARA MOBILE/TABLET
      /// ===========================
      drawer: (Responsive.isMobile(context) || Responsive.isTablet(context)) 
          ? _buildDrawer(context) 
          : null,

      body: Padding(
        padding: EdgeInsets.all(Responsive.isMobile(context) ? 16.0 : 20.0),
        child: Column(
          children: [
            /// ===== MENU SUPERIOR APENAS NO DESKTOP =====
            if (Responsive.isDesktop(context))
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFe5e5e5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMenuButton(context, "Home",
                          onTap: () => _navigateToRoute(context, '/prof')),
                      _buildMenuButton(context, "Tópicos",
                          onTap: () => _navigateToRoute(context, '/folders_prof')),
                      _buildMenuButton(context, "Galeria", isActive: true),
                    ],
                  ),
                ),
              ),

            if (Responsive.isDesktop(context)) const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showImagemDialog(context),
                  icon: const Icon(Icons.add),
                  label: Text(
                    "Adicionar Imagem",
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
              child: imagens.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF003b64),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Responsive.isMobile(context) 
                            ? 2 
                            : Responsive.isTablet(context) 
                                ? 3 
                                : 4,
                        crossAxisSpacing: Responsive.isMobile(context) ? 12 : 16,
                        mainAxisSpacing: Responsive.isMobile(context) ? 12 : 16,
                        childAspectRatio: Responsive.isMobile(context) ? 0.8 : 0.9,
                      ),
                      itemCount: imagens.length,
                      itemBuilder: (context, index) {
                        final img = imagens[index];
                        final id = img['_id'] ?? '';
                        final titulo = img['nomeImagem'] ?? 'Sem título';
                        final descricao = img['descricao'] ?? '';
                        final previewPath = img['previewPath'] ?? '';
                        final listFolders = img['diretorios'] ?? [];

                        return Card(
                          color: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            content: const Text(
                                                "aqui entra o código do Leo"),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text("Fechar"),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: previewPath.isNotEmpty
                                          ? Image.network(
                                              "http://localhost:3000/tiles/$previewPath",
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                   Icon(
                                                Icons.broken_image,
                                                size: Responsive.isMobile(context) ? 40 : 50,
                                                color: Colors.grey,
                                              ),
                                            )
                                          : const Center(
                                              child: Icon(
                                                Icons.image,
                                                size: 50,
                                                color: Colors.grey,
                                              ),
                                            ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(Responsive.isMobile(context) ? 6.0 : 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          titulo,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Responsive.isMobile(context) ? 12 : 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          descricao,
                                          style: TextStyle(
                                            fontSize: Responsive.isMobile(context) ? 10 : 12,
                                          ),
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
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit,
                                          color: const Color(0xFF003b64),
                                          size: Responsive.isMobile(context) ? 18 : 24),
                                      tooltip: "Editar imagem",
                                      onPressed: () =>
                                          _showImagemDialog(context, img: img),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete,
                                          color: Colors.redAccent,
                                          size: Responsive.isMobile(context) ? 18 : 24),
                                      tooltip: "Excluir imagem",
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: const Text("Excluir imagem"),
                                            content: Text(
                                                "Tem certeza que deseja excluir '$titulo'?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, false),
                                                  child:
                                                      const Text("Cancelar")),
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.redAccent),
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, true),
                                                  child: const Text("Excluir")),
                                            ],
                                          ),
                                        );
                                        if (confirm == true) {
                                          await deleteImagem(id);
                                        }
                                      },
                                    ),
                                  ],
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

  /// ===== DRAWER PARA MOBILE/TABLET =====
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

  /// ===== BOTÃO DE MENU =====
  Widget _buildMenuButton(BuildContext context, String label,
      {bool isActive = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
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