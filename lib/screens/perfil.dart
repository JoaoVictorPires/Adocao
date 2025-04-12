import 'package:flutter/material.dart';
import 'alterarsenha.dart'; // Importe a tela de alterar senha
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import para Firestore

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        // Buscando dados do usuário no Firestore
        future: FirebaseFirestore.instance.collection('usuarios').doc(user?.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Carregando dados
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Usuário não encontrado.'));
          }

          var userData = snapshot.data!;
          
          // Pega os dados do Firestore
          String nome = userData['nome'] ?? 'Nome não disponível';
          bool gostaDeCachorro = userData['gostaDeCachorro'] ?? false;
          bool gostaDeGato = userData['gostaDeGato'] ?? false;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView( // Usado para permitir rolagem caso os elementos ultrapassem a tela
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exibindo o nome do usuário
                  Text(
                    'Nome: $nome',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  
                  // Exibindo o e-mail do usuário
                  Text(
                    'E-mail: ${user?.email ?? 'Carregando...'}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  
                  // Exibindo a preferência de pet
                  Text(
                    'Preferência de pet: ${gostaDeCachorro ? 'Cachorro' : gostaDeGato ? 'Gato' : 'Nenhum escolhido'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 30),
                  
                  // Botão para alterar a senha
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AlterarSenhaScreen(),
                        ),
                      );
                    },
                    child: const Text('Alterar Senha'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Botão para deletar a conta
                  ElevatedButton(
                    onPressed: () async {
                      // Exibe um alerta antes de deletar
                      bool? confirmDelete = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Deletar Conta'),
                          content: const Text('Você tem certeza que deseja deletar sua conta? Esta ação não pode ser desfeita.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Deletar'),
                            ),
                          ],
                        ),
                      );

                      if (confirmDelete == true) {
                        try {
                          await user?.delete(); // Deleta a conta do usuário
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Conta deletada com sucesso!')),
                          );
                          Navigator.pushReplacementNamed(context, '/login');
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro ao deletar a conta: $e')),
                          );
                        }
                      }
                    },
                    child: const Text('Deletar Conta'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}