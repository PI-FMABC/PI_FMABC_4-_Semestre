import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'responsive.dart';

class HomeProfScreen extends StatefulWidget {
  const HomeProfScreen({super.key});

  @override
  State<HomeProfScreen> createState() => _HomeProfScreenState();
}

class _HomeProfScreenState extends State<HomeProfScreen> {
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
        final data = json.decode(response.body);
        setState(() {
          folders = data.reversed.take(6).toList(); // pega os 6 mais recentes
        });
      } else {
        throw Exception('Erro ao carregar pastas: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao buscar pastas: $e');
    }
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
      /// NAVBAR SUPERIOR
      /// ===========================
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

      /// ===========================
      /// DRAWER
      /// ===========================
      drawer: (Responsive.isMobile(context) || Responsive.isTablet(context))
          ? _buildDrawer(context)
          : null,

      /// ===========================
      /// CONTEÚDO PRINCIPAL
      /// ===========================
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Responsive.isMobile(context) ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===== MENU SUPERIOR DESKTOP =====
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
                      _buildMenuButton(context, "Home", isActive: true),
                      _buildMenuButton(context, "Tópicos",
                          onTap: () =>
                              Navigator.pushNamed(context, '/folders_prof')),
                      _buildMenuButton(context, "Galeria",
                          onTap: () =>
                              Navigator.pushNamed(context, '/gallery_prof')),
                    ],
                  ),
                ),
              ),
            if (Responsive.isDesktop(context)) const SizedBox(height: 28),

            /// ===== SEÇÃO INTRO =====
            Text(
              "Bem-vindo ao painel do professor",
              style: TextStyle(
                fontSize: Responsive.isMobile(context) ? 20 : 28,
                color: const Color(0xFF003b64),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Gerencie diretórios e imagens do Atlas Digital.",
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 20),

            /// ===== GRID DE DIRETÓRIOS MAIS USADOS =====
            const Text(
              "Diretórios Mais Usados",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF003b64),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            folders.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF003b64)),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: folders.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Responsive.isMobile(context) ? 2 : 3,
                      crossAxisSpacing: Responsive.isMobile(context) ? 12 : 16,
                      mainAxisSpacing: Responsive.isMobile(context) ? 12 : 16,
                      childAspectRatio:
                          Responsive.isMobile(context) ? 0.85 : 0.9,
                    ),
                    itemBuilder: (context, index) {
                      final folder = folders[index];
                      final titulo = folder['titulo'] ?? 'Sem título';
                      final descricao = folder['descricao'] ?? 'Sem descrição';
                      final listIMG = (folder['listIMG'] ?? []) as List;

                      return Card(
                        color: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                titulo,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      Responsive.isMobile(context) ? 14 : 16,
                                  color: const Color(0xFF003b64),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                descricao,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize:
                                      Responsive.isMobile(context) ? 12 : 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              if (listIMG.isNotEmpty)
                                SizedBox(
                                  height:
                                      Responsive.isMobile(context) ? 80 : 100,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: listIMG.map<Widget>((img) {
                                      String previewPath = '';
                                      if (img is Map &&
                                          img['previewPath'] != null) {
                                        previewPath = img['previewPath'];
                                      }
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: GestureDetector(
                                          onTap: () {
                                            List<String> parts = previewPath.split('/');
                                            final filename = parts.first;
                                            
                                            Navigator.pushNamed(
                                              context, 
                                              '/image-viewer-prof',
                                              arguments: {
                                                'imageFilename': filename
                                              }
                                            );
                                          },
                                          child: Container(
                                            width: Responsive.isMobile(context)
                                                ? 70
                                                : 80,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 1.5),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: AspectRatio(
                                                aspectRatio: 1,
                                                child: previewPath.isNotEmpty
                                                    ? Image.network(
                                                        "http://localhost:3000/tiles/$previewPath",
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (_, __,
                                                                ___) =>
                                                            const Icon(
                                                                Icons
                                                                    .broken_image,
                                                                size: 30,
                                                                color: Colors
                                                                    .grey),
                                                      )
                                                    : const Icon(
                                                        Icons.broken_image,
                                                        size: 30,
                                                        color: Colors.grey),
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
                                    child: Icon(Icons.folder,
                                        size: 60, color: Color(0xFF003b64)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

            const SizedBox(height: 36),
            Center(
              child: Text(
                "© ${DateTime.now().year} FMABC — Atlas Digital de Citologia",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: Responsive.isMobile(context) ? 12 : 14,
                ),
              ),
            ),
          ],
        ),
      ),

      /// ===========================
      /// BOTÃO FLUTUANTE ADICIONAR
      /// ===========================
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_gallery');
        },
        backgroundColor: const Color(0xFF009245),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// ===== DRAWER =====
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF003b64)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Atlas de Histologia',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Modo Professor',
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home Professor'),
            onTap: () {
              Navigator.pop(context);
              _navigateToRoute(context, '/home_prof');
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
                  content: const Text('Logout realizado com sucesso!',
                      style: TextStyle(fontSize: 16)),
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
      child: GestureDetector(
        onTap: onTap,
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
    );
  }
}
