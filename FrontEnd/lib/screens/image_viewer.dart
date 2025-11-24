import 'package:flutter/material.dart';
import 'responsive.dart';
import 'visualizacao_imagens.dart';

class ImageViewerScreen extends StatelessWidget {
  const ImageViewerScreen({super.key});

  void _navigateToRoute(BuildContext context, String routeName) {
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushNamed(context, routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final imageFilename = args?['imageFilename'] ?? '';

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
              // LOGO + TÍTULO
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

              // BOTÃO LOGIN (APENAS DESKTOP)
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
            horizontal: Responsive.isMobile(context) ? 16 : 24,
            vertical: Responsive.isMobile(context) ? 16 : 20,
          ),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMenuButton(context, "Home",
                            onTap: () => Navigator.pushNamed(context, '/')),
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

              /// ===== ÁREA DE CONTEÚDO =====
              Responsive.isMobile(context)
                  ? _buildMobileLayout(context, imageFilename)
                  : _buildDesktopLayout(context, imageFilename),

              const SizedBox(height: 36),

              /// ===== RODAPÉ =====
              Center(
                child: Text(
                  "© ${DateTime.now().year} FMABC — Atlas Digital de Histologia",
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

  /// ===== LAYOUT PARA MOBILE =====
  Widget _buildMobileLayout(BuildContext context, String imageFilename) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF003b64)),
          label: const Text(
            "Voltar",
            style: TextStyle(
              color: Color(0xFF003b64),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // IMAGEM PRINCIPAL
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF003b64), width: 1.2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ImageCanvas(imageFileName: imageFilename)
          ),
        ),

        const SizedBox(height: 20),

        // PAINEL DE ANOTAÇÕES (EMBAIXO DA IMAGEM NO MOBILE)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Anotações",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF003b64),
                ),
              ),
              const SizedBox(height: 10),

              /// LISTA DE ANOTAÇÕES
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.push_pin, color: Color(0xFF003b64)),
                      title: Text("Anotação ${index + 1}"),
                      subtitle: const Text("Descrição breve..."),
                    ),
                  );
                },
              ),

              const Divider(thickness: 1.2),
              const SizedBox(height: 10),

              const Text(
                "Adicionar Pin:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003b64),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.push_pin),
                      label: const Text("Pin"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003b64),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                      label: const Text("Nota"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF003b64),
                        side: const BorderSide(color: Color(0xFF003b64), width: 1.2),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ===== LAYOUT PARA DESKTOP/TABLET =====
  Widget _buildDesktopLayout(BuildContext context, String imageFilename) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ===== ÁREA PRINCIPAL DA IMAGEM =====
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Color(0xFF003b64)),
                label: const Text(
                  "Voltar",
                  style: TextStyle(
                    color: Color(0xFF003b64),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                height: Responsive.isTablet(context) ? 400 : 500,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF003b64), width: 1.2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ImageCanvas(imageFileName: imageFilename)
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: Responsive.isTablet(context) ? 16 : 24),

        /// ===== PAINEL LATERAL =====
        Container(
          width: Responsive.isTablet(context) ? 220 : 280,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Anotações",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF003b64),
                ),
              ),
              const SizedBox(height: 10),

              /// LISTA DE ANOTAÇÕES
              ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.push_pin, color: Color(0xFF003b64)),
                      title: Text("Anotação ${index + 1}"),
                      subtitle: const Text("Descrição breve..."),
                    ),
                  );
                },
              ),

              const Divider(thickness: 1.2),
              const SizedBox(height: 10),

              const Text(
                "Adicionar Pin:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003b64),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.push_pin),
                      label: const Text("Pin"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003b64),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                      label: const Text("Nota"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF003b64),
                        side: const BorderSide(color: Color(0xFF003b64), width: 1.2),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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

  /// ===== BOTÃO DE MENU =====
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