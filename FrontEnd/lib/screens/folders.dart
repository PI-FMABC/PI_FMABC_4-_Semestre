import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'responsive.dart';

class FoldersScreen extends StatefulWidget {
  const FoldersScreen({super.key});

  @override
  State<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  List<dynamic> folders = [];

  @override
  void initState() {
    super.initState();
    fetchFolders();
  }

  Future<void> fetchFolders() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/diretorio'),
      );
      if (response.statusCode == 200) {
        setState(() {
          folders = json.decode(response.body);
        });
      } else {
        throw Exception('Erro ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Erro ao buscar diretorios: $e");
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
                padding: EdgeInsets.only(left: Responsive.isMobile(context) ? 12 : 20),
                child: Row(
                  children: [
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
              if (Responsive.isDesktop(context))
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF003b64),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.person),
                    label: const Text("Login"),
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

      /// ===========================
      /// CONTEÚDO PRINCIPAL
      /// ===========================
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile(context) ? 16 : 32,
            vertical: Responsive.isMobile(context) ? 16 : 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ===== MENU SUPERIOR APENAS NO DESKTOP =====
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
                            onTap: () => Navigator.pushNamed(context, '/')),
                        _buildMenuButton(context, "Tópicos",
                            isActive: true,
                            onTap: () =>
                                Navigator.pushNamed(context, '/folders')),
                        _buildMenuButton(context, "Galeria",
                            onTap: () =>
                                Navigator.pushNamed(context, '/gallery')),
                      ],
                    ),
                  ),
                ),

              if (Responsive.isDesktop(context)) const SizedBox(height: 28),

              /// ===== GRID DE PASTAS (DINÂMICO) =====
              folders.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(
                          color: Color(0xFF003b64),
                        ),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: folders.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Responsive.isMobile(context) ? 1 : 2,
                        crossAxisSpacing: Responsive.isMobile(context) ? 12 : 16,
                        mainAxisSpacing: Responsive.isMobile(context) ? 12 : 16,
                        childAspectRatio: Responsive.isMobile(context) ? 1.5 : 1.3,
                      ),
                      itemBuilder: (context, index) {
                        final folder = folders[index];
                        final String titulo = folder['titulo'] ?? 'Sem título';
                        final String descricao =
                            folder['descricao'] ?? 'Sem descrição';
                        final List listIMG =
                            (folder['listIMG'] ?? []) as List<dynamic>;

                        return GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/index'),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: const Color(0xFF003b64)),
                            ),
                            padding: EdgeInsets.all(Responsive.isMobile(context) ? 10 : 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// ===== TÍTULO =====
                                Text(
                                  titulo,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF003b64),
                                    fontSize: Responsive.isMobile(context) ? 16 : 18,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                SizedBox(height: Responsive.isMobile(context) ? 4 : 6),

                                /// ===== DESCRIÇÃO =====
                                Text(
                                  descricao,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: Responsive.isMobile(context) ? 13 : 14,
                                    height: 1.3,
                                  ),
                                  maxLines: Responsive.isMobile(context) ? 3 : 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: Responsive.isMobile(context) ? 8 : 10),

                                /// ===== IMAGENS (caso existam) =====
                                if (listIMG.isNotEmpty)
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children:
                                          listIMG.take(3).map<Widget>((img) {
                                        return Padding(
                                          padding:
                                              EdgeInsets.only(right: Responsive.isMobile(context) ? 6 : 8),
                                          child: Image.network(
                                            img,
                                            height: Responsive.isMobile(context) ? 50 : 60,
                                            width: Responsive.isMobile(context) ? 50 : 60,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                Icon(
                                              Icons.broken_image,
                                              size: Responsive.isMobile(context) ? 30 : 40,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                else
                                  Center(
                                    child: Icon(
                                      Icons.folder,
                                      size: Responsive.isMobile(context) ? 40 : 50,
                                      color: const Color(0xFF003b64),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

              const SizedBox(height: 40),

              /// ===== RODAPÉ =====
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
                  'Navegação',
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
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text('Tópicos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/folders');
            },
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Galeria'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/gallery');
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Índice'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/index');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Login'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  /// Botões do menu superior
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