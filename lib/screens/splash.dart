import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adocaopet/screens/lista_de_pets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? animalPreferido;
  bool _isVisible = false; // Controla a visibilidade do ícone para o fade
  bool _navigating = false; // Controla o estado da navegação

  @override
  void initState() {
    super.initState();
    _verificarPreferencia();
  }

  // Função para verificar a preferência do usuário no Firebase
  Future<void> _verificarPreferencia() async {
    User? usuario = FirebaseAuth.instance.currentUser;

    if (usuario != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(usuario.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          animalPreferido = snapshot['gostaDeCachorro'] == true
              ? 'cachorro'
              : snapshot['gostaDeGato'] == true
                  ? 'gato'
                  : null;
        });
      }
    }

    // Atraso para exibir rapidamente a pata e em seguida preparar a navegação
    await Future.delayed(const Duration(milliseconds: 500)); // Menos tempo para aparecer a pata

    setState(() {
      _isVisible = true; // Exibe o ícone rapidamente
    });

    // Atraso para dar tempo do efeito de fade e depois navegar para a próxima tela
    await Future.delayed(const Duration(seconds: 1));

    // Inicia o fade e navega para a próxima tela
    _navegarParaListaDePets();
  }

  // Função para navegar para a tela de ListaDePets com fade
  void _navegarParaListaDePets() {
    if (!_navigating) {
      setState(() {
        _navigating = true; // Previne múltiplas navegações
      });
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation, // Aplicando o fade na transição para a nova tela
              child: const ListaDePets(),
            );
          },
          transitionDuration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: animalPreferido == null
            ? const CircularProgressIndicator() // Exibe um loading enquanto a preferência não é carregada
            : AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500), // Mais rápido, 500ms para aparecer o ícone
                child: Icon(
                  animalPreferido == 'cachorro' ? Icons.pets : Icons.pets_outlined,
                  size: 100,
                  color: animalPreferido == 'cachorro'
                      ? Colors.blue 
                      : Colors.green,
                ),
              ),
      ),
    );
  }
}
