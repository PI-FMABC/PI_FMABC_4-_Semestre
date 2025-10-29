import 'package:flutter/material.dart';

class FoldersProfScreen extends StatelessWidget {
  const FoldersProfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      /// ---------------------- APPBAR ----------------------
      appBar: AppBar(
        backgroundColor: const Color(0xFF003b64),
        title: const Text(
          "Atlas de Citologia - Modo Professor",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton.icon(
              onPressed: () => Navigator.pushReplacementNamed(context, '/'),
              icon: const Icon(Icons.logout, color: Color(0xFF003b64)),
              label: const Text(
                "Sair",
                style: TextStyle(
                  color: Color(0xFF003b64),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),

      /// ---------------------- BODY ----------------------
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Cabeçalho: texto + botão de adicionar pasta
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Células e Tecidos",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color(0xFF003b64),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Os tecidos são classificados em quatro tipos básicos: "
                        "epitelial, tecido conjuntivo (inclui cartilagem, osso e sangue), "
                        "muscular e tecido nervoso.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add_folder');
                  },
                  icon: const Icon(Icons.create_new_folder),
                  label: const Text("Adicionar Pasta"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003b64),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// ---------------------- GRID DE PASTAS ----------------------
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.15,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.pushNamed(context, '/index_prof'),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.folder,
                                  size: 55, color: Color(0xFF003b64)),
                              const SizedBox(height: 10),
                              Text(
                                "Pasta ${index + 1}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text("Título da pasta",
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),

                          /// Botões de ação: editar / excluir
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Color(0xFF003b64)),
                                  tooltip: "Editar pasta",
                                  onPressed: () {
                                    // Função futura de edição
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  tooltip: "Excluir pasta",
                                  onPressed: () {
                                    // Função futura de exclusão
                                  },
                                ),
                              ],
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
      ),

      /// ---------------------- MENU INFERIOR ----------------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color(0xFF003b64),
        unselectedItemColor: Colors.grey[600],
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/prof');
          if (i == 1) Navigator.pushReplacementNamed(context, '/folders_prof');
          if (i == 2) Navigator.pushReplacementNamed(context, '/index_prof');
          if (i == 3) Navigator.pushReplacementNamed(context, '/gallery_prof');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: "Pastas"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Índice"),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: "Galeria"),
        ],
      ),
    );
  }
}
