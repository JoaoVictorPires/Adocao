import 'package:flutter/material.dart';

class FormularioAdocao extends StatelessWidget {
  final Map<String, String> pet;
  const FormularioAdocao({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Formulário de Adoção'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Você está adotando ${pet['nome']}!'),
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
                },
                child: const Text('Enviar Solicitação'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
