import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AlterarSenhaScreen extends StatefulWidget {
  const AlterarSenhaScreen({super.key});

  @override
  _AlterarSenhaScreenState createState() => _AlterarSenhaScreenState();
}

class _AlterarSenhaScreenState extends State<AlterarSenhaScreen> {
  final _senhaAtualController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  // Função para alterar a senha
  void _alterarSenha() async {
    final user = _auth.currentUser;

    // Verificando se o usuário está logado
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário não autenticado!')),
      );
      return;
    }

    try {
      // Verificando se a senha atual está correta
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _senhaAtualController.text.trim(),
      );

      // Reautenticando o usuário para verificar a senha atual
      await user.reauthenticateWithCredential(credential);

      // Verificando se as novas senhas são iguais
      if (_novaSenhaController.text.trim() != _confirmarSenhaController.text.trim()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('As senhas não coincidem!')),
        );
        return;
      }

      // Atualizando a senha
      await user.updatePassword(_novaSenhaController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Senha alterada com sucesso!')),
      );

      // Redireciona para a tela de perfil ou home após alteração
      Navigator.pop(context); // Volta para a tela anterior (perfil)
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao alterar senha: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alterar Senha'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _senhaAtualController,
              decoration: const InputDecoration(
                labelText: 'Senha Atual',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _novaSenhaController,
              decoration: const InputDecoration(
                labelText: 'Nova Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmarSenhaController,
              decoration: const InputDecoration(
                labelText: 'Confirmar Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _alterarSenha,
              child: const Text('Alterar Senha'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }
}
