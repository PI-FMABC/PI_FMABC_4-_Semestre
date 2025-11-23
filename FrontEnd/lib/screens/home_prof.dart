import 'package:flutter/material.dart';
import 'responsive.dart';

class HomeProfScreen extends StatelessWidget {
  const HomeProfScreen({super.key});

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
                    onPressed: () {
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
                        _buildMenuButton(context, "Home", isActive: true),
                        _buildMenuButton(context, "Tópicos",
                            onTap: () => Navigator.pushNamed(context, '/folders_prof')),
                        _buildMenuButton(context, "Galeria",
                            onTap: () => Navigator.pushNamed(context, '/gallery_prof')),
                      ],
                    ),
                  ),
                ),

              if (Responsive.isDesktop(context)) const SizedBox(height: 28),

              /// ===== SEÇÃO INTRO =====
              Responsive.isMobile(context)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Atlas de Histologia - Modo Professor",
                          style: TextStyle(
                            fontSize: 20,
                            color: const Color(0xFF003b64),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Bem-vindo ao painel do professor. Gerencie diretórios e imagens do Atlas Digital.",
                          style: TextStyle(fontSize: 14, height: 1.5),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => Navigator.pushNamed(context, '/folders_prof'),
                              icon: const Icon(Icons.folder_open, size: 18),
                              label: const Text("Tópicos", style: TextStyle(fontSize: 14)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF003b64),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton.icon(
                              onPressed: () => Navigator.pushNamed(context, '/gallery_prof'),
                              icon: const Icon(Icons.image, size: 18),
                              label: const Text("Galeria", style: TextStyle(fontSize: 14)),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF003b64),
                                side: const BorderSide(color: Color(0xFF003b64), width: 1.2),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF003b64)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Diretório em destaque",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF003b64),
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Center(
                                  child: Icon(Icons.folder_outlined,
                                      size: 36, color: Color(0xFF003b64)),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Epitélio Escamoso — amostras selecionadas",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => Navigator.pushNamed(context, '/folders_prof'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF009245),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  child: const Text("Abrir diretório", style: TextStyle(fontSize: 14)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Atlas de Histologia - Modo Professor",
                                style: TextStyle(
                                  fontSize: Responsive.isTablet(context) ? 24 : 28,
                                  color: const Color(0xFF003b64),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Bem-vindo ao painel do professor. Gerencie diretórios e imagens do Atlas Digital.",
                                style: TextStyle(fontSize: 16, height: 1.5),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => Navigator.pushNamed(context, '/folders_prof'),
                                    icon: const Icon(Icons.folder_open),
                                    label: const Text("Gerenciar Diretórios"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF003b64),
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  OutlinedButton.icon(
                                    onPressed: () => Navigator.pushNamed(context, '/gallery_prof'),
                                    icon: const Icon(Icons.image),
                                    label: const Text("Gerenciar Galeria"),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFF003b64),
                                      side: const BorderSide(color: Color(0xFF003b64), width: 1.2),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFF003b64)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Diretório em destaque",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF003b64),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.folder_outlined,
                                        size: 48, color: Color(0xFF003b64)),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  "Epitélio Escamoso — amostras selecionadas",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () => Navigator.pushNamed(context, '/folders_prof'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF009245),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text("Abrir diretório"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

              const SizedBox(height: 28),

              /// ===== DIRETÓRIOS MAIS USADOS =====
              const Text(
                "Diretórios Mais Usados",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF003b64),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Responsive.isMobile(context) ? 2 : 3,
                  crossAxisSpacing: Responsive.isMobile(context) ? 12 : 16,
                  mainAxisSpacing: Responsive.isMobile(context) ? 12 : 16,
                  childAspectRatio: Responsive.isMobile(context) ? 1.0 : 1.15,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/folders_prof'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFF009245),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(Responsive.isMobile(context) ? 8 : 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.folder,
                            color: Color(0xFF003b64),
                            size: 50,
                          ),
                          SizedBox(height: Responsive.isMobile(context) ? 6 : 10),
                          Text(
                            "Diretório ${index + 1}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF003b64),
                              fontSize: Responsive.isMobile(context) ? 14 : 16,
                            ),
                          ),
                          Text(
                            "Título",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: Responsive.isMobile(context) ? 12 : 14,
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