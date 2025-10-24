import 'package:flutter/material.dart';

class FoldersScreen extends StatelessWidget {
  const FoldersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// ===========================
      /// NAVBAR SUPERIOR
      /// ===========================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: const Color(0xFF003b64),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // LOGO + TÍTULO
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

              // BOTÃO LOGIN
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
      /// CONTEÚDO PRINCIPAL
      /// ===========================
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ===== MENU SUPERIOR =====
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
                          onTap: () => Navigator.pushNamed(context, '/folders')),
                      _buildMenuButton(context, "Galeria",
                          onTap: () => Navigator.pushNamed(context, '/gallery')),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              /// ===== TÍTULO E DESCRIÇÃO =====
              const Text(
                "Tecidos e Orgãos",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Color(0xFF003b64),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Os tecidos são classificados em quatro tipos básicos: epitelial, conjuntivo (inclui cartilagem, osso e sangue), muscular e nervoso.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),

              /// ===== GRID DE PASTAS =====
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.15,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/index'),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF003b64)),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // IMAGEM DA PASTA
                          Image.asset(
                            'assets/logo.png',
                            height: 60,
                            width: 60,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.folder,
                              size: 50,
                              color: Color(0xFF003b64),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Pasta ${index + 1}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003b64),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Título da Pasta",
                            style: TextStyle(color: Colors.black87),
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
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
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
