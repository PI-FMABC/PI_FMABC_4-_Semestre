import 'package:flutter/material.dart';

class ImageViewerProfScreen extends StatelessWidget {
  const ImageViewerProfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// NAVBAR FMABC (sem seta de voltar)
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: const Color(0xFF003b64),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // LOGO + TÍTULO
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Image.asset(
                      'lib/assets/logo.png',
                      height: 55,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Atlas de Histologia",
                      style: TextStyle(
                        color: Color(0xFF009245),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // BOTÃO SAIR (professor)
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green[600],
                        content: const Text('Logout realizado com sucesso!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF003b64),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text("Sair"),
                ),
              ),
            ],
          ),
        ),
      ),

      /// CONTEÚDO PRINCIPAL
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          children: [
            // Menu topo (Home / Diretórios / Galeria) - "Galeria" ou "Índice" pode ser ativo conforme contexto
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
                    _buildMenuButton(context, "Home",
                        onTap: () => Navigator.pushNamed(context, '/prof')),
                    _buildMenuButton(context, "Diretórios",
                        onTap: () =>
                            Navigator.pushNamed(context, '/folders_prof')),
                    _buildMenuButton(context, "Galeria",
                        onTap: () =>
                            Navigator.pushNamed(context, '/gallery_prof')),
                    _buildMenuButton(context, "Índice",
                        onTap: () => Navigator.pushNamed(context, '/index_prof')),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Área principal: imagem grande + painel lateral com edição
            Expanded(
              child: Row(
                children: [
                  // Área da imagem (maior)
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: const Color(0xFF003b64), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // título da imagem e ações rápidas
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Título da Imagem",
                                  style: TextStyle(
                                      color: Color(0xFF003b64),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        // futura função: adicionar pin interativo
                                      },
                                      icon: const Icon(Icons.push_pin_outlined,
                                          color: Color(0xFF003b64)),
                                      tooltip: 'Adicionar pin',
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        // futura função: rotacionar ou espelhar
                                      },
                                      icon: const Icon(Icons.rotate_right,
                                          color: Color(0xFF003b64)),
                                      tooltip: 'Rotacionar',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // área da imagem (mock)
                          Expanded(
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/folder_image.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.image_outlined,
                                    size: 140,
                                    color: Color(0xFF003b64),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // barra inferior com zoom (visual apenas)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    color: Color(0xFF003b64)),
                                Row(
                                  children: const [
                                    Text("100%"),
                                    SizedBox(width: 8),
                                    Icon(Icons.remove, color: Color(0xFF003b64)),
                                    SizedBox(width: 4),
                                    Icon(Icons.add, color: Color(0xFF003b64)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Painel lateral de edição (professor)
                  Container(
                    width: 320,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Editar Imagem",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003b64),
                              fontSize: 18),
                        ),
                        const SizedBox(height: 12),

                        // Import / upload (visual)
                        ElevatedButton.icon(
                          onPressed: () {
                            // futura função: importar imagem
                          },
                          icon: const Icon(Icons.upload_file),
                          label: const Text("Importar imagem"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF003b64),
                            side: const BorderSide(color: Color(0xFF003b64)),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Título editável (visual)
                        const Text("Título:"),
                        const SizedBox(height: 6),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Adicionar título",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Selecionar diretório (visual)
                        const Text("Selecionar diretório:"),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          items: const [
                            DropdownMenuItem(value: 'd1', child: Text('Diretório 1')),
                            DropdownMenuItem(value: 'd2', child: Text('Diretório 2')),
                          ],
                          onChanged: (_) {},
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Descrição
                        const Text("Descrição:"),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 100,
                          child: TextField(
                            maxLines: 6,
                            decoration: InputDecoration(
                              hintText: "Inserir descrição",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Ações: salvar e excluir
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // futura ação: salvar metadata
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green[600],
                                      content: const Text('Alterações salvas'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.green,
                                  side: const BorderSide(color: Colors.green),
                                ),
                                child: const Text("Salvar Imagem"),
                                
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  // futura ação: excluir imagem
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Confirmar exclusão'),
                                      content: const Text(
                                          'Deseja realmente excluir esta imagem?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    Colors.red[600],
                                                content: const Text(
                                                    'Imagem excluída'),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Excluir',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: const Text("Excluir"),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                          ],
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
    );
  }

  Widget _buildMenuButton(BuildContext context, String label,
      {bool isActive = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF003b64) : Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
