import 'package:flutter/material.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({super.key});

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
      /// CORPO PRINCIPAL
      /// ===========================
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
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
                          onTap: () => Navigator.pushNamed(context, '/folders')),
                      _buildMenuButton(context, "Galeria",
                          onTap: () => Navigator.pushNamed(context, '/gallery')),
                      _buildMenuButton(context, "Índice", isActive: true),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              /// ===== ÁREA DE CONTEÚDO =====
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ==== SIDEBAR ====
                  Container(
                    width: 200,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Índice de Imagens",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF003b64),
                          ),
                        ),
                        const Divider(thickness: 1),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text("#AA"),
                          onTap: () {},
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text("#BB"),
                          onTap: () {},
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text("#CC"),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),

                  /// ==== GRID DE IMAGENS ====
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/image-viewer'),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: const Color(0xFF003b64)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.asset(
                                      'assets/folder_image.png',
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.image_outlined,
                                        color: Color(0xFF003b64),
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Imagem ${index + 1}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
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

              const SizedBox(height: 36),

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