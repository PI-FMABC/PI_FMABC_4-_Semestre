import 'package:flutter/material.dart';

class HomeProfScreen extends StatelessWidget {
  const HomeProfScreen({super.key});

  void _navigateToRoute(BuildContext context, String routeName) {
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushReplacementNamed(context, routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// ===========================
      /// NAVBAR SUPERIOR FMABC
      /// ===========================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: const Color(0xFF003b64),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // LOGO E TÍTULO
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

              // BOTÃO DE SAIR
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
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
      /// CONTEÚDO PRINCIPAL
      /// ===========================
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== TÍTULO CENTRAL =====
            const Center(
              child: Text(
                "Atlas de Histologia - Modo Professor",
                style: TextStyle(
                  color: Color(0xFF003b64),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                "Bem-vindo ao painel do professor. Gerencie diretórios e imagens do Atlas Digital.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 28),

            // ===== SEÇÃO DE DIRETÓRIOS =====
            const Text(
              "Diretórios Mais Usados",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF003b64),
              ),
            ),
            const SizedBox(height: 16),

            // ===== GRID DE DIRETÓRIOS =====
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/folders_prof'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFF009245), width: 2),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.folder,
                            color: Color(0xFF003b64),
                            size: 50,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Diretório ${index + 1}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003b64),
                            ),
                          ),
                          const Text(
                            "Título",
                            style: TextStyle(color: Colors.black54),
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

      /// ===========================
      /// MENU INFERIOR
      /// ===========================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (i) {
          if (i == 0) _navigateToRoute(context, '/prof');
          if (i == 1) _navigateToRoute(context, '/folders_prof');
          if (i == 2) _navigateToRoute(context, '/index_prof');
          if (i == 3) _navigateToRoute(context, '/gallery_prof');
        },
        selectedItemColor: const Color(0xFF009245),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: "Diretórios"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Índice"),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: "Galeria"),
        ],
      ),
    );
  }
}
