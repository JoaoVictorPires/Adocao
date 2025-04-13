import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  bool _lovesDog = false;
  bool _lovesCat = false;

  void _register() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
        'email': _emailController.text.trim(),
        'nome': _nameController.text.trim(),
        'gostaDeCachorro': _lovesDog,
        'gostaDeGato': _lovesCat,
        'criadoEm': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),
      appBar: AppBar(
        title: const Text('Cadastro'),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 32),
            const Icon(Icons.pets, size: 60, color: Colors.deepPurple),
            const SizedBox(height: 16),
            const Text(
              'Crie sua conta',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Checkbox(
                  value: _lovesDog,
                  onChanged: (value) {
                    setState(() {
                      _lovesDog = value!;
                      if (_lovesDog) _lovesCat = false;
                    });
                  },
                ),
                const Text("Amo Cachorro 🐶"),
                const SizedBox(width: 16),
                Checkbox(
                  value: _lovesCat,
                  onChanged: (value) {
                    setState(() {
                      _lovesCat = value!;
                      if (_lovesCat) _lovesDog = false;
                    });
                  },
                ),
                const Text("Amo Gato 🐱"),
              ],
            ),

            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: _register,
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text('Cadastrar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
    _nameController.dispose();
    super.dispose();
  }
}
