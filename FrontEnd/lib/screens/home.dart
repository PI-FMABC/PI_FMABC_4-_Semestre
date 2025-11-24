import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'responsive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          folders = data.reversed.take(3).toList(); 
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

  
  void _showLeoAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Preview clicado"),
        content: const Text("Aqui você precisa adicionar o código do Leo"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
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

   
      drawer: (Responsive.isMobile(context) || Responsive.isTablet(context))
          ? _buildDrawer(context)
          : null,

    
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Responsive.isMobile(context) ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      _buildMenuButton(context, "Home", isActive: true),
                      _buildMenuButton(context, "Tópicos",
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

         
            Text(
              "Bem-vindo ao Atlas Digital de Histologia",
              style: TextStyle(
                fontSize: Responsive.isMobile(context) ? 20 : 28,
                color: const Color(0xFF003b64),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Explore imagens histológicas em alta resolução, anote observações e consulte materiais organizados por tópicos.",
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 20),

          
            const Text(
              "Pastas mais usadas",
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Responsive.isMobile(context) ? 2 : 3,
                      crossAxisSpacing: Responsive.isMobile(context) ? 12 : 16,
                      mainAxisSpacing: Responsive.isMobile(context) ? 12 : 16,
                      childAspectRatio:
                          Responsive.isMobile(context) ? 0.85 : 0.9,
                    ),
                    itemCount: folders.length,
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
                                          onTap: () => _showLeoAlert(context),
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
                                                        errorBuilder:
                                                            (_, __, ___) =>
                                                                const Icon(
                                                          Icons.broken_image,
                                                          size: 30,
                                                          color: Colors.grey,
                                                        ),
                                                      )
                                                    : const Icon(
                                                        Icons.broken_image,
                                                        size: 30,
                                                        color: Colors.grey,
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
    );
  }


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
                Text(
                  'Atlas de Histologia',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Navegação',
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              _navigateToRoute(context, '/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text('Tópicos'),
            onTap: () {
              Navigator.pop(context);
              _navigateToRoute(context, '/folders');
            },
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Galeria'),
            onTap: () {
              Navigator.pop(context);
              _navigateToRoute(context, '/gallery');
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Índice'),
            onTap: () {
              Navigator.pop(context);
              _navigateToRoute(context, '/index');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Login'),
            onTap: () {
              Navigator.pop(context);
              _navigateToRoute(context, '/login');
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
