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
      body: FutureBuilder<DocumentSnapshot>(
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
          String nome = userData['nome'] ?? 'Nome não disponível';
          bool gostaDeCachorro = userData['gostaDeCachorro'] ?? false;
          bool gostaDeGato = userData['gostaDeGato'] ?? false;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFEDE7F6), Color(0xFFD1C4E9)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Topo com botão de voltar
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, size: 28, color: Colors.deepPurple),
                        onPressed: () {
                          Navigator.pop(context); // Voltar para a tela anterior
                        },
                      ),
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.pets, size: 60, color: Colors.deepPurple),
                                const SizedBox(height: 16),
                                Text(
                                  nome,
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  user?.email ?? 'E-mail não disponível',
                                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Preferência: ${gostaDeCachorro ? 'Cachorro 🐶' : gostaDeGato ? 'Gato 🐱' : 'Nenhum'}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 32),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.lock_reset),
                                  label: const Text('Alterar Senha'),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const AlterarSenhaScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 48),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.delete, color: Colors.white),
                                  label: const Text('Deletar Conta', style: TextStyle(color: Colors.white)),
                                  onPressed: () async {
                                    bool? confirmDelete = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Deletar Conta'),
                                        content: const Text('Tem certeza? Essa ação não pode ser desfeita.'),
                                        actions: [
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
                                        await user?.delete();
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
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    minimumSize: const Size(double.infinity, 48),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
