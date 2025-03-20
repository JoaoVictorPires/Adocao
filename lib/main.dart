import 'package:flutter/material.dart';
import 'screens/lista_de_pets.dart';
import 'screens/login.dart';
import 'themes.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: MaterialApp(
        title: 'Adoção de Pets',
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor), // Usando colorScheme para trabalhar com as cores
          scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: AppColors.primaryTextColor),
            bodyMedium: TextStyle(color: AppColors.secondaryTextColor),
            titleLarge: TextStyle(color: AppColors.appBarTextColor), // Correção para headline6
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
