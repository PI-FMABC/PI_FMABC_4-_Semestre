import 'package:flutter/material.dart';

class AddGalleryScreen extends StatelessWidget {
  const AddGalleryScreen({super.key});

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
            /// Título
            const Text(
              'Adicionar nova imagem à galeria',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003b64),
              ),
            ),
            const SizedBox(height: 24),

            /// Formulário principal
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Coluna esquerda: título + descrição
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Inserir título',
                            hintText: 'Título da imagem...',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFF003b64)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFF003b64)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF003b64),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: 'Inserir descrição',
                            hintText: 'Descrição detalhada da imagem...',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFF003b64)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFF003b64)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF003b64),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 32),

                  /// Coluna direita: diretório + botões
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Selecionar diretório',
                            hintText: 'Digite o nome do diretório...',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFF003b64)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFF003b64)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF003b64),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        /// Botão importar imagem
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Lógica futura: importar imagem
                            },
                            icon: const Icon(Icons.image),
                            label: const Text('Importar Imagem'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF003b64),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(0, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        /// Botão salvar imagem
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Lógica futura: salvar imagem
                            },
                            icon: const Icon(Icons.save),
                            label: const Text('Salvar Imagem'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF003b64),
                              side: const BorderSide(color: Color(0xFF003b64)),
                              minimumSize: const Size(0, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
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

      /// ---------------------- MENU INFERIOR ----------------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: const Color(0xFF003b64),
        unselectedItemColor: Colors.grey[600],
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
