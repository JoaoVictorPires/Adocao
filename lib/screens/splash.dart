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
  bool _isVisible = false; 
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    _verificarPreferencia();
  }

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

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isVisible = true; 
    });

    await Future.delayed(const Duration(seconds: 1));

    _navegarParaListaDePets();
  }

  void _navegarParaListaDePets() {
    if (!_navigating) {
      setState(() {
        _navigating = true;
      });
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
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
            ? const CircularProgressIndicator()
            : AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
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
