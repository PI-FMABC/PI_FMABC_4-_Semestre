import 'package:flutter/material.dart';

class AddGallery extends StatelessWidget {
  const AddGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003b64),
        title: const Text("Atlas de Citologia"),
        actions: [],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Adicionar nova imagem a galeria',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Inserir título',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Inserir descrição',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),


                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Selecionar diretório',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // LÓGICA IMPORTAR IMAGEM
                            },
                            icon: const Icon(Icons.image),
                            label: const Text('Importar Imagem'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 48),
                              backgroundColor: Colors.white
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // LÓGICA SALVAR IMAGEM
                            },
                            icon: const Icon(Icons.save),
                            label: const Text('Salvar imagem'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: const Size(0, 48),
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