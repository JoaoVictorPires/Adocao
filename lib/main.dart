import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/lista_de_pets.dart';
import 'screens/login.dart';
import 'themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa o Firebase
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Fecha o teclado ao clicar fora
      },
      child: MaterialApp(
        title: 'Adoção de Pets',
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
          scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: AppColors.primaryTextColor),
            bodyMedium: TextStyle(color: AppColors.secondaryTextColor),
            titleLarge: TextStyle(color: AppColors.appBarTextColor),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.appBarColor,
            titleTextStyle: TextStyle(color: AppColors.appBarTextColor),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: AppColors.buttonColor,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/listaDePets': (context) => const ListaDePets(),
        },
      ),
    );
  }
}
