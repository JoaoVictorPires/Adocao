
import 'package:adocaopet/screens/perfil.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // <- Importante!
import 'screens/lista_de_pets.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({Key? key}) : super(key: key);

  Future<FirebaseApp> _initializeFirebase() async {
    return await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  'Erro ao iniciar o app:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: MaterialApp(
            title: 'Adoção de Pets',
            theme: _buildThemeData(),
            initialRoute: '/login',
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => RegisterScreen(), 
              '/listaDePets': (context) => const ListaDePets(),
              '/perfil': (context) => const PerfilScreen(),
            },
          ),
        );
      },
    );
  }

  ThemeData _buildThemeData() {
    return ThemeData(
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
        titleTextStyle: TextStyle(
          color: AppColors.appBarTextColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: AppColors.appBarTextColor),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.buttonColor,
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }
}
