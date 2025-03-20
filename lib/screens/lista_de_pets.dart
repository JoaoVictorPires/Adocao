import 'package:flutter/material.dart';
import 'detalhes_do_pet.dart';
import '../models/pet.dart';

class ListaDePets extends StatelessWidget {
  const ListaDePets({super.key});

  final List<Pet> pets = const [
    Pet(nome: 'Rex', idade: '2 anos', imagem: 'assets/images/triste-cachorro.jpg'),
    Pet(nome: 'Luna', idade: '1 ano', imagem: 'assets/images/triste-cachorro.jpg'),
    Pet(nome: 'Camunzika', idade: '12 anos', imagem: 'assets/images/camunizk.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cães para Adoção'),
      ),
      body: ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
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
