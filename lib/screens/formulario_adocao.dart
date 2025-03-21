import 'package:adocaopet/themes.dart';
import 'package:flutter/material.dart';
import '../models/pet.dart';

class FormularioAdocao extends StatelessWidget {
  final Pet pet;
  const FormularioAdocao({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Formulário de Adoção'),
        iconTheme: IconThemeData(color: Colors.white)
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Você está adotando ${pet.nome}!'),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: 'Nome Completo'),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: 'Telefone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: 'Por que deseja adotar?'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pedido enviado com sucesso!'),
                    ),
                  );
                  Navigator.pop(context);
                },style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 4, 221, 131),
              ),
                child: const Text('Enviar Solicitação', style: TextStyle(color: Colors.black),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
