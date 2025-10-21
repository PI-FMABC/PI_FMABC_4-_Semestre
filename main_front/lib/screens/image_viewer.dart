import 'package:flutter/material.dart';

class ImageViewerScreen extends StatefulWidget {
  const ImageViewerScreen({super.key});

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  double zoomLevel = 100;

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
              // LOGO E TÍTULO
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 55,
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
      /// CONTEÚDO PRINCIPAL
      /// ===========================
      body: Column(
        children: [
          /// ===== MENU SUPERIOR =====
          const SizedBox(height: 16),
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
                  _buildMenuButton(context, "Home", onTap: () {
                    Navigator.pushNamed(context, '/');
                  }),
                  _buildMenuButton(context, "Tópicos", onTap: () {
                    Navigator.pushNamed(context, '/folders');
                  }),
                  _buildMenuButton(context, "Galeria",
                      isActive: true, onTap: () {
                    Navigator.pushNamed(context, '/gallery');
                  }),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// ===== ÁREA PRINCIPAL =====
          Expanded(
            child: Row(
              children: [
                /// BOTÃO VOLTAR + IMAGEM
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Color(0xFF003b64)),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF003b64),
                                width: 1,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.image,
                                size: 120,
                                color: Color(0xFF003b64),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// ===== CONTROLES DE ZOOM =====
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.location_on_outlined,
                                color: Color(0xFF003b64)),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove,
                                      color: Color(0xFF003b64)),
                                  onPressed: () {
                                    setState(() {
                                      if (zoomLevel > 10) zoomLevel -= 10;
                                    });
                                  },
                                ),
                                Text(
                                  "${zoomLevel.toInt()}%",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add,
                                      color: Color(0xFF003b64)),
                                  onPressed: () {
                                    setState(() {
                                      if (zoomLevel < 1000) zoomLevel += 10;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                /// ===== PAINEL DE ANOTAÇÕES =====
                Container(
                  width: 280,
                  color: Colors.grey[100],
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Anotações:",
                        style: TextStyle(
                          color: Color(0xFF003b64),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Card(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading: const Icon(Icons.push_pin,
                                    color: Color(0xFF003b64)),
                                title: Text("Anotação ${index + 1}"),
                                subtitle: const Text("Descrição breve"),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF003b64),
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.add_comment_outlined),
                          label: const Text("Adicionar Anotação"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ====== COMPONENTE DE BOTÕES DO MENU ======
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
