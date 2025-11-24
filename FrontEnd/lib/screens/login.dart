import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  Future<void> _fazerLogin(BuildContext context) async {
    final email = _emailController.text.trim();
    final senha = _passwordController.text.trim();
    
    try {
  
      final responseProf = await http.post(
        Uri.parse('http://localhost:3000/professores/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'senha': senha,
        }),
      );
      
      if (responseProf.statusCode == 200) {
       
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[600],
            content: const Text(
              'Login bem-sucedido!',
              style: TextStyle(fontSize: 16),
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );

        
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context, '/prof');
        });
      }
     
      else {
        
        final responseAdmin = await http.post(
          Uri.parse('http://localhost:3000/admin/login'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': email,
            'senha': senha,
          }),
        );
      
        if (responseAdmin.statusCode == 200) {
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green[600],
              content: const Text(
                'Login de administrador bem-sucedido!',
                style: TextStyle(fontSize: 16),
              ),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );

         
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacementNamed(context, '/adm');
          });
        }
      
        else {
     
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Email ou senha incorretos.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }

    } catch (e) {
      debugPrint("Erro ao validar o login do usuário");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003b64),

     
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Image.asset(
          'lib/assets/logo.png',
          height: 50,
        ),
        centerTitle: false,
      ),

 
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFEFEFEF),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                
                const Text("Email:"),
                const SizedBox(height: 5),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),

             
                const Text("Senha:"),
                const SizedBox(height: 5),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Senha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

           
                ElevatedButton(
                  onPressed: () => _fazerLogin(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009245),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    "Fazer Login",
                    style: TextStyle(
                      color: Colors.white,
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
