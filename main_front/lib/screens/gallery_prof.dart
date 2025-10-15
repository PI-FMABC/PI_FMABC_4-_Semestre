import 'package:flutter/material.dart';

    void _navigateToRoute(BuildContext context, String routeName) {
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushNamed(context, routeName);
    }
  }

class GalleryProfScreen extends StatelessWidget {
  const GalleryProfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003b64),
        title: const Text("Atlas de Citologia"),
        actions: [
          TextButton(
            onPressed: () => _navigateToRoute(context, '/'),
            child: const Text("HOME", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => _navigateToRoute(context, '/folders'),
            child: const Text("DIRETÓRIOS", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => _navigateToRoute(context, '/gallery'),
            child: const Text("GALERIA", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => _navigateToRoute(context, '/prof'),
            child: const Text("Login Professor", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              const Text(
                "Galeria Geral de Imagens",
                style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/add_gallery');
                },
                icon: const Icon(Icons.add),
                label: const Text("Adicionar à Galeria"),
                style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003b64),
                foregroundColor: Colors.white,
                ),
              ),
              ],
            ),
            const SizedBox(height: 16),

            /// Grid de imagens
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // quantidade de colunas
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 20, // número de imagens
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/image-viewer'),
                    child: Card(
                      elevation: 2,
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.grey,
                        ),
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
        currentIndex: 3,
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
