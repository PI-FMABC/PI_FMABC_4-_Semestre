import 'package:flutter/material.dart';

class LoginTela extends StatelessWidget {
  const LoginTela({super.key});

  // TEMPORARIO P/ ENTRAR NA TELA DE PROFESSOR
  void _fazerLogin(BuildContext context, String email, String senha) {
    if (email == 'prof@gmail.com' && senha == 'prof123') {
      Navigator.pushReplacementNamed(context, '/prof');
    } 
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final senhaController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Professor'),
        backgroundColor: const Color(0xFF003b64),
      ),
      body: Container(
        color: Colors.grey[100],
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: const Color(0xFF003b64),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                
                // email
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    labelStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // senha
                TextField(
                  controller: senhaController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    labelStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // entrar
                ElevatedButton(
                  onPressed: () {
                    _fazerLogin(
                      context,
                      emailController.text.trim(),
                      senhaController.text.trim(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF003b64),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}