
import 'package:flutter/material.dart';

class AddFoldersScreen extends StatelessWidget {
  const AddFoldersScreen({super.key});

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
                        "Adicionar Novo Diretório",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                //PASTTA
                
              ],
            ),
            Center(
              child: SizedBox(
                width: 400,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Título do diretório',
                    hintText: 'Título do diretório',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Row(
              children: [

                Expanded(
                flex: 2,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                  ),
                  itemCount: 20,
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
                SizedBox(width: 24),

                Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text(
                    "Descrição do diretório",
                    style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                    TextField(
                    maxLines: 10,
                    decoration: const InputDecoration(
                      hintText: "Digite a descrição do diretório...",
                      border: OutlineInputBorder(),
                    ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // LÓGICA DE CRIAÇÃO DE DIRETÓRIO
                      },
                      style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003b64),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                      'Criar Diretório',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
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
      ),

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