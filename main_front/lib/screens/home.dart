import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// ===========================
      /// NAVBAR SUPERIOR (consistente com as outras telas)
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
                      'assets/logo.png',
                      height: 55,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Atlas de Citologia",
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
                  onPressed: () {},
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
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // MENU SUPERIOR (Home ativo)
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
                      _buildMenuButton(context, "Home", isActive: true, onTap: () {
                        // já estamos na home
                      }),
                      _buildMenuButton(context, "Tópicos", onTap: () {
                        Navigator.pushNamed(context, '/folders');
                      }),
                      _buildMenuButton(context, "Galeria", onTap: () {
                        Navigator.pushNamed(context, '/gallery');
                      }),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // HERO / INTRO
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Coluna esquerda: texto + ações
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Bem-vindo ao Atlas Digital de Citologia",
                          style: TextStyle(
                            fontSize: 28,
                            color: Color(0xFF003b64),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Explore imagens citológicas em alta resolução, "
                          "anote pontos relevantes e consulte materiais organizados "
                          "por tópicos. Projetado para estudo e pesquisa — "
                          "compatível com desktop, tablet e mobile.",
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => Navigator.pushNamed(context, '/folders'),
                              icon: const Icon(Icons.folder_open),
                              label: const Text("Explorar Tópicos"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF003b64),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 14),
                              ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: () => Navigator.pushNamed(context, '/gallery'),
                              icon: const Icon(Icons.image),
                              label: const Text("Ver Galeria"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF003b64),
                                side: const BorderSide(color: Color(0xFF003b64)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Coluna direita: cartão destacado (ex.: pasta em destaque)
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFF003b64), width: 1),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tópico em destaque",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF003b64)),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Center(child: Icon(Icons.image_outlined, size: 48, color: Color(0xFF003b64))),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Epitélio Escamoso — amostras selecionadas",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, '/index'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF009245),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              minimumSize: const Size.fromHeight(36),
                            ),
                            child: const Text("Abrir tópico"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // SEÇÃO: Pastas mais utilizadas (grid)
              const Text(
                "Pastas mais usadas",
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.15,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/folders'),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF003b64)),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.folder, size: 44, color: Color(0xFF003b64)),
                          const SizedBox(height: 10),
                          Text(
                            "Pasta ${index + 1}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text("XX imagens"),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 28),

              // SEÇÃO: Atividade recente / Últimas imagens
              const Text(
                "Últimas adicionadas",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF003b64),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 140,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 8,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/image-viewer'),
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFF003b64)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Center(child: Icon(Icons.image_outlined, size: 36, color: Color(0xFF003b64))),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text("Imagem de exemplo"),
                            const SizedBox(height: 4),
                            Text(
                              "upload • 01/10/2025",
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 36),

              // RODAPÉ (simples)
              Center(
                child: Text(
                  "© ${DateTime.now().year} FMABC — Atlas Digital de Citologia",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  /// Botões do menu superior (reaproveitados)
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
