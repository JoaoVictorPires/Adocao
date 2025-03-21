import 'package:adocaopet/themes.dart';
import 'package:flutter/material.dart';
import '../models/pet.dart';
import 'formulario_adocao.dart'; 

class DetalhesDoPet extends StatefulWidget {
  final Pet pet;

  const DetalhesDoPet({super.key, required this.pet});

  @override
  _DetalhesDoPetState createState() => _DetalhesDoPetState();
}

class _DetalhesDoPetState extends State<DetalhesDoPet> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(widget.pet.nome),
        iconTheme: IconThemeData(color: Colors.white), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _toggleExpand,
              child: Container(
                constraints: BoxConstraints(maxHeight: 300),
                child: ClipRect( 
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1 + _animation.value * 0.5,
                        child: child,
                      );
                    },
                    child: Image.asset(widget.pet.imagem),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(widget.pet.nome, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Idade: ${widget.pet.idade}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text('Descrição:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              constraints: BoxConstraints(maxHeight: 100),
              child: const Text(
                'Este pet está procurando um novo lar. Ele é amigável e adora brincadeiras.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormularioAdocao(pet: widget.pet),
                      
                    ),
                  );
                  
                },
                style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor,
              ),
                child: const Text('Adotar',style: TextStyle(color: Colors.black),),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
