import 'package:adocaopet/themes.dart';
import 'package:flutter/material.dart';
import 'detalhes_do_pet.dart';
import '../models/pet.dart';

class ListaDePets extends StatelessWidget {
  const ListaDePets({super.key});

  final List<Pet> pets = const [
    Pet(nome: 'Rex', idade: '2 anos', imagem: 'assets/images/triste-cachorro.jpg'),
    Pet(nome: 'Luna', idade: '1 ano', imagem: 'assets/images/triste-cachorro.jpg'),
    Pet(nome: 'Camunzika', idade: '12 anos', imagem: 'assets/images/camunizk.jpg'),
    Pet(nome: 'Bolinha', idade: '3 anos', imagem: 'assets/images/camunizk.jpg'),
    Pet(nome: 'Pretinha', idade: '5 anos', imagem: 'assets/images/camunizk.jpg'),
    Pet(nome: 'Rex', idade: '2 anos', imagem: 'assets/images/triste-cachorro.jpg'),
    Pet(nome: 'Luna', idade: '1 ano', imagem: 'assets/images/triste-cachorro.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Pets para Adoção'),
        titleTextStyle: TextStyle(color: Colors.white),
        actions: [
          // Botão de perfil no canto superior direito
          IconButton(
            icon: const Icon(Icons.account_circle), // Ícone de perfil
            onPressed: () {
              Navigator.pushNamed(context, '/perfil'); // Navega para a tela de perfil
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout), // Ícone de logout
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login'); // Navega para o login
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 5,
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipOval(
                    child: Image.asset(
                      pets[index].imagem,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              title: Text(pets[index].nome),
              subtitle: Text(pets[index].idade),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalhesDoPet(pet: pets[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
