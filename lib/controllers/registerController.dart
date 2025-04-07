import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final cpfController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> registerUser(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );

        String uid = userCredential.user?.uid ?? '';

        if (uid.isEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to create user')));
          return;
        }

        CollectionReference users = FirebaseFirestore.instance.collection(
          'User',
        );

        await users.doc(uid).set({
          'name': nameController.text,
          'dob': dobController.text,
          'cpf': cpfController.text,
          'email': emailController.text,
          'value': 0.0,
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Registration Successful')));

        _clearFields();

        Navigator.pushReplacementNamed(context, '/home');
      } on FirebaseAuthException catch (e) {
        String errorMessage =
            e.message ?? 'An error occurred during registration.';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Registration Failed')));
      }
    }
  }

  void _clearFields() {
    emailController.clear();
    nameController.clear();
    dobController.clear();
    cpfController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void dispose() {
    emailController.dispose();
    nameController.dispose();
    dobController.dispose();
    cpfController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}