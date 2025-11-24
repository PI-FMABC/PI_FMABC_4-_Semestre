import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdmScreen extends StatefulWidget {
  const AdmScreen({super.key});

  @override
  State<AdmScreen> createState() => _AdmScreenState();
}

class _AdmScreenState extends State<AdmScreen> {

  List<Map<String, dynamic>> professores = [];

  Future<void> fetchProfessores() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/professores'),
      );
      if (response.statusCode == 200) {
        setState(() {
          List<dynamic> responseJsonList = json.decode(response.body);
          professores.clear();
          professores = List<Map<String, dynamic>>.from(responseJsonList);
        });
      } else {
        throw Exception('Erro ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Erro ao buscar professores: $e");
    }
  }

  void _adicionarProfessor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddProfessorDialog(
        onProfessorAdicionado: (novoProfessor) async {
          try {
            final response = await http.post(
              Uri.parse('http://localhost:3000/professores'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({
                'email': novoProfessor['email'],
                'nome': novoProfessor['nome'],
                'senha': novoProfessor['senha'],
              }),
            );
            if (response.statusCode == 200) {
              setState(() {
                professores.add(novoProfessor);
              });
            } else {
              throw Exception('Erro ao adicionar dados: ${response.statusCode}');
            }
          } catch (e) {
            debugPrint("Erro ao adicionar professores: $e");
          }
        },
      ),
    );
  }

  void _editarProfessor(BuildContext context, Map<String, dynamic> professor, int index) {
    showDialog(
      context: context,
      builder: (context) => EditProfessorDialog(
        professor: professor,
        index: index,
        onProfessorEditado: (professorEditado, index) async {
          try {
            final response = await http.put(
              Uri.parse('http://localhost:3000/professores'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({
                'email': professorEditado['email'],
                'nome': professorEditado['nome'],
                'senha': professorEditado['senha'],
                'oldEmail': professor['email'],
              }),
            );
            if (response.statusCode == 200) {
              setState(() {
                professores[index] = professorEditado;
              });
            } else {
              throw Exception('Erro ao editar dados: ${response.statusCode}');
            }
          } catch (e) {
            debugPrint("Erro ao editar professores: $e");
          }
        },
      ),
    );
  }

  void _deletarProfessor(BuildContext context, Map<String, dynamic> professor, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja excluir o professor ${professor['nome']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final response = await http.delete(
                  Uri.parse('http://localhost:3000/professores/${professor['email']}')
                );
                if (response.statusCode == 200) {
                  setState(() {
                    professores.removeAt(index);
                  });
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green[600],
                      content: Text('Professor ${professor['nome']} excluído com sucesso!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } catch (e) {
                debugPrint("Erro ao deletar professores: $e");
              }
              
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchProfessores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// ===========================
      /// NAVBAR SUPERIOR
      /// ===========================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: const Color(0xFF003b64),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                      "Atlas de Histologia - Admin",
                      style: TextStyle(
                        color: Color(0xFF009245),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF003b64),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.exit_to_app),
                  label: const Text("Sair"),
                ),
              ),
            ],
          ),
        ),
      ),

      /// ===========================
      /// CONTEÚDO PRINCIPAL
      /// ===========================
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          /// ===========================
          /// TABELAS
          /// ===========================
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                        /// ===========================
                        /// PARTE ESQUERDA - ESTATÍSTICAS
                        /// ===========================
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF003b64)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Estatísticas do Sistema",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF003b64),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildStatCard("Total de Acessos", "0"),
                          const SizedBox(height: 12),
                          _buildStatCard("Acessos Hoje", "0"),
                          const SizedBox(height: 12),
                          _buildStatCard("Professores Ativos", professores.length.toString()),
                          const SizedBox(height: 12),
                          _buildStatCard("Imagens no Sistema", "0"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  /// ===========================
                  /// PARTE DIREITA - LISTA DE PROFESSORES
                  /// ===========================
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF003b64)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          // Cabeçalho da tabela
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xFF003b64),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Professores Autorizados",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _adicionarProfessor(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF009245),
                                    foregroundColor: Colors.white,
                                  ),
                                  icon: const Icon(Icons.person_add),
                                  label: const Text("Adicionar Professor"),
                                ),
                              ],
                            ),
                          ),

                          // Corpo da tabela
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              child: professores.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'Nenhum professor cadastrado',
                                        style: TextStyle(fontSize: 16, color: Colors.grey),
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      itemCount: professores.length,
                                      itemBuilder: (context, index) {
                                        final professor = professores[index];
                                        return Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey[300]!,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          child: ListTile(
                                            contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            title: Text(
                                              professor['nome']!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text(professor['email']!),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  onPressed: () => _editarProfessor(context, professor, index),
                                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                                  tooltip: 'Editar',
                                                ),
                                                IconButton(
                                                  onPressed: () => _deletarProfessor(context, professor, index),
                                                  icon: const Icon(Icons.delete, color: Colors.red),
                                                  tooltip: 'Deletar',
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Center(
              child: Text(
                "© ${DateTime.now().year} FMABC — Painel Administrativo",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003b64),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===========================
/// POPUP PARA ADICIONAR PROFESSOR
/// ===========================
class AddProfessorDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onProfessorAdicionado;

  const AddProfessorDialog({super.key, required this.onProfessorAdicionado});

  @override
  State<AddProfessorDialog> createState() => _AddProfessorDialogState();
}

class _AddProfessorDialogState extends State<AddProfessorDialog> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  void _adicionarProfessor() {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (nome.isNotEmpty && email.isNotEmpty && senha.isNotEmpty) {
      final novoProfessor = {
        'nome': nome,
        'email': email,
        'senha': senha,
      };
      
      widget.onProfessorAdicionado(novoProfessor);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green[600],
          content: const Text('Professor adicionado com sucesso!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Preencha todos os campos!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Adicionar Professor",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003b64),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Text("Nome:"),
            const SizedBox(height: 5),
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                hintText: 'Nome completo do professor',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 15),
            const Text("Email:"),
            const SizedBox(height: 5),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'email@fmabc.br',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 15),
            const Text("Senha:"),
            const SizedBox(height: 5),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Senha de acesso',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _adicionarProfessor,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009245),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text(
                  "Adicionar Professor",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===========================
/// POPUP PARA EDITAR PROFESSOR
/// ===========================
class EditProfessorDialog extends StatefulWidget {
  final Map<String, dynamic> professor;
  final int index;
  final Function(Map<String, dynamic>, int) onProfessorEditado;

  const EditProfessorDialog({
    super.key,
    required this.professor,
    required this.index,
    required this.onProfessorEditado,
  });

  @override
  State<EditProfessorDialog> createState() => _EditProfessorDialogState();
}

class _EditProfessorDialogState extends State<EditProfessorDialog> {
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _senhaController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.professor['nome']);
    _emailController = TextEditingController(text: widget.professor['email']);
    _senhaController = TextEditingController(text: widget.professor['senha']);
  }

  void _editarProfessor() {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (nome.isNotEmpty && email.isNotEmpty && senha.isNotEmpty) {
      final professorEditado = {
        'nome': nome,
        'email': email,
        'senha': senha,
      };
      
      widget.onProfessorEditado(professorEditado, widget.index);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green[600],
          content: const Text('Professor editado com sucesso!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Preencha todos os campos!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Editar Professor",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003b64),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Text("Nome:"),
            const SizedBox(height: 5),
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 15),
            const Text("Email:"),
            const SizedBox(height: 5),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 15),
            const Text("Senha:"),
            const SizedBox(height: 5),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _editarProfessor,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009245),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text(
                  "Salvar Alterações",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}