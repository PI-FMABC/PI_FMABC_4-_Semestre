import 'package:flutter/material.dart';

class ImageViewerScreen extends StatelessWidget {
  const ImageViewerScreen({super.key});

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

      body: Row(
        children: [
          /// Área principal da imagem
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Painel lateral (anotações e pins)
          Container(
            width: 250,
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Anotações:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),

                  /// Lista de anotações (mock por enquanto)
                  Expanded(
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.push_pin,
                                color: Colors.blue),
                            title: Text("Anotação ${index + 1}"),
                            subtitle: const Text("Descrição curta"),
                          ),
                        );
                      },
                    ),
                  ),

                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    "Adicionar Pin:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.push_pin),
                        label: const Text("Pin"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                        label: const Text("Nota"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      /// Menu inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: -1, // Nenhum marcado porque é tela secundária
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
