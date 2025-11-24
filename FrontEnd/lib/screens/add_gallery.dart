import 'package:flutter/material.dart';
import 'responsive.dart'; // ajuste o caminho conforme sua estrutura de pastas

class AddGalleryScreen extends StatefulWidget {
  const AddGalleryScreen({super.key});

  @override
  State<AddGalleryScreen> createState() => _AddGalleryScreenState();
}

class _AddGalleryScreenState extends State<AddGalleryScreen> {
  String? _selectedDirectory;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // mock diretórios - troque por dados reais quando tiver
  final List<String> _directories = ['Diretório 1', 'Diretório 2', 'Diretório 3'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green[600],
        content: const Text(
          'Logout realizado com sucesso!',
          style: TextStyle(fontSize: 16),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _saveImage() {
    // ação mock de salvar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green[600],
        content: const Text('Imagem salva com sucesso!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _importImage() {
    // abrir picker real no futuro
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Abrir seletor de imagem'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openDescriptionEditor() {
    // alternativa: abrir um dialog para descrição grande
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Inserir Descrição'),
        content: SizedBox(
          width: double.maxFinite,
          child: TextField(
            controller: _descriptionController,
            maxLines: 8,
            decoration: const InputDecoration(
              hintText: 'Digite a descrição da imagem...',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003b64)),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

PreferredSizeWidget _buildNavBar(BuildContext context) {
  return PreferredSize(
    preferredSize: Size.fromHeight(Responsive.isMobile(context) ? 70 : 80),
    child: Container(
      color: const Color(0xFF003b64),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: Responsive.isMobile(context) ? 12 : 20),
            child: Row(
              children: [
                if (Responsive.isMobile(context) || Responsive.isTablet(context))
                  Builder(
                    builder: (ctx) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () => Scaffold.of(ctx).openDrawer(),
                    ),
                  ),
                IconButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/prof'),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                Image.asset(
                  'lib/assets/logo.png',
                  height: Responsive.isMobile(context) ? 45 : 55,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
                SizedBox(width: Responsive.isMobile(context) ? 6 : 10),
                Responsive.isMobile(context)
                    ? const Text(
                        "Atlas",
                        style: TextStyle(
                          color: Color(0xFF009245),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const Text(
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
          if (Responsive.isDesktop(context))
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
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
  );
}

  Widget _buildDrawer() {
    // Drawer que aparece em mobile/tablet (contendo as mesmas rotas e logout)
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pushReplacementNamed(context, '/prof'),
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Diretórios'),
              onTap: () => Navigator.pushReplacementNamed(context, '/folders_prof'),
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Galeria'),
              onTap: () => Navigator.pushReplacementNamed(context, '/gallery_prof'),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // largura disponível para ajustar proporções
    final width = MediaQuery.of(context).size.width;

    // para desktop: layout horizontal com card esquerdo e painel direito
    // para mobile: empilhar verticalmente
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildNavBar(context),
      drawer: (Responsive.isMobile(context) || Responsive.isTablet(context)) ? _buildDrawer() : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Espaço superior (se precisar de um subtítulo)
            const SizedBox(height: 8),

            // Conteúdo principal
            Expanded(
              child: isMobile
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          // card de import + descrição
                          Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  // Importar imagem (botão grande)
                                  SizedBox(
                                    width: double.infinity,
                                    height: 120,
                                    child: OutlinedButton(
                                      onPressed: _importImage,
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Colors.black12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8)),
                                        backgroundColor: Colors.white,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.upload_outlined, size: 30, color: Colors.black54),
                                          SizedBox(height: 8),
                                          Text('importar imagem', style: TextStyle(color: Colors.black87)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Inserir descrição (grande botão/área)
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _openDescriptionEditor,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black87,
                                        padding: const EdgeInsets.symmetric(vertical: 18),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text('Inserir Descrição', style: TextStyle(color: Colors.black87)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // painel direito transformado em seção abaixo (título + dropdown + salvar)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Adicionar título', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003b64))),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _titleController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    hintText: 'Título da imagem...',
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text('Selecionar diretório', style: TextStyle(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: _selectedDirectory,
                                  items: _directories.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                                  onChanged: (v) => setState(() => _selectedDirectory = v),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _saveImage,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF009245),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Salvar Imagem', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card esquerdo: importar + descrição
                        Expanded(
                          flex: 2,
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  // Importar imagem
                                  SizedBox(
                                    width: double.infinity,
                                    height: 120,
                                    child: OutlinedButton(
                                      onPressed: _importImage,
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Colors.black12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                        backgroundColor: Colors.white,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.upload_outlined, size: 34, color: Colors.black54),
                                          SizedBox(height: 8),
                                          Text('importar imagem', style: TextStyle(color: Colors.black87)),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Inserir descrição (grande botão/área)
                                  SizedBox(
                                    width: double.infinity,
                                    height: 120,
                                    child: ElevatedButton(
                                      onPressed: _openDescriptionEditor,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black87,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text('Inserir Descrição', style: TextStyle(color: Colors.black87)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 24),

                        // Painel direito: título + diretório + salvar
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              const Text('Adicionar título', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003b64))),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _titleController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  hintText: 'Título da imagem...',
                                ),
                              ),
                              const SizedBox(height: 18),
                              const Text('Selecionar diretório', style: TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: _selectedDirectory,
                                items: _directories.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                                onChanged: (v) => setState(() => _selectedDirectory = v),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _saveImage,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF009245),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Salvar Imagem', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              const SizedBox(height: 8),
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
}
