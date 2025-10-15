import 'package:flutter/material.dart';

class FoldersProfScreen extends StatelessWidget {
  const FoldersProfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003b64),
        title: const Text("Atlas de Citologia - Professor"),
        actions: [
          TextButton(
            onPressed: () {
              // volta para a home normal MUDAR
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text(
              "Sair",
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
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add_folder_prof');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003b64),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Bordas arredondadas
              ),
            ),
            child: const Text(
              "ADICIONAR\nPASTA",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),

            /// Grid de pastas
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, 
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: 6, 
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(context, '/index_prof'),
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
          if (i == 0) Navigator.pushReplacementNamed(context, '/prof');
          if (i == 1) Navigator.pushReplacementNamed(context, '/folders_prof');
          if (i == 2) Navigator.pushNamed(context, '/index_prof');
          if (i == 3) Navigator.pushNamed(context, '/gallery_prof');
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