import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- Import Firestore aqui

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController(); // Controller para o nome
  final _auth = FirebaseAuth.instance;

  // Variáveis para armazenar a escolha do usuário
  bool _lovesDog = false;
  bool _lovesCat = false;

  void _register() async {
    try {
      // Cadastra o usuário com email e senha
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Pegando o UID do usuário criado
      String uid = userCredential.user!.uid;

      // Salvando dados no Firestore
      await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
        'email': _emailController.text.trim(),
        'nome': _nameController.text.trim(),  // Salvando nome
        'gostaDeCachorro': _lovesDog,  // Salvando se ama cachorro
        'gostaDeGato': _lovesCat,  // Salvando se ama gato
        'criadoEm': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo para nome
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            // Campo para e-mail
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            // Campo para senha
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),

            // Checkbox para escolher cachorro ou gato
            Row(
              children: [
                Checkbox(
                  value: _lovesDog,
                  onChanged: (value) {
                    setState(() {
                      _lovesDog = value!;
                      // Se escolher cachorro, desmarcar gato
                      if (_lovesDog) _lovesCat = false;
                    });
                  },
                ),
                Text("Amo Cachorro"),
                SizedBox(width: 20),
                Checkbox(
                  value: _lovesCat,
                  onChanged: (value) {
                    setState(() {
                      _lovesCat = value!;
                      // Se escolher gato, desmarcar cachorro
                      if (_lovesCat) _lovesDog = false;
                    });
                  },
                ),
                Text("Amo Gato"),
              ],
            ),

            SizedBox(height: 20),

            // Botão de cadastro
            ElevatedButton(
              onPressed: _register,
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();  // Liberando o controller do nome
    super.dispose();
  }
}
