import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            const Center(
              child: Text(
                "<descrição do sistema>",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Pastas Mais Usadas",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(context, '/folders'),
                      child: const Center(
                        child: Text("Pasta com IMG\nTítulo"),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
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
