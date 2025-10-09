import 'package:flutter/material.dart';

class FoldersScreen extends StatelessWidget {
  const FoldersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003b64),
        title: const Text("Atlas de Citologia"),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Login Professor",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Células e Tecidos",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Os tecidos são classificados em quatro tipos básicos: "
              "epitelial, tecido conjuntivo (inclui cartilagem, osso e sangue), "
              "muscular e tecido nervoso.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            /// Grid de pastas
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // quantidade de colunas
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: 6, // número de pastas
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(context, '/index'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.folder, size: 50, color: Colors.blue),
                          const SizedBox(height: 10),
                          Text(
                            "Pasta com IMG",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text("Título"),
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

      /// Menu inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (i) {
          if (i == 0) Navigator.pushNamed(context, '/');
          if (i == 1) Navigator.pushNamed(context, '/folders');
          if (i == 2) Navigator.pushNamed(context, '/index');
          if (i == 3) Navigator.pushNamed(context, '/gallery');
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
