import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:rice_app/constant/routes.dart';
import 'package:rice_app/services/auth/auth_exceptions.dart';
import 'package:rice_app/services/auth/auth_service.dart';
import 'package:rice_app/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Your Password'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase()
                    .createUser(email: email, password: password);
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                // ignore: use_build_context_synchronously
                await showErrorDialog(
                  context,
                  "Weak Password",
                );
              } on EmailAlreadyInUseAuthException {
                // ignore: use_build_context_synchronously
                await showErrorDialog(
                  context,
                  "Email Already Exist",
                );
              } on InvalidEmailInUseAuthException {
                // ignore: use_build_context_synchronously
                await showErrorDialog(
                  context,
                  "Invalide Email",
                );
              } on GenericAuthException {
                // ignore: use_build_context_synchronously
                await showErrorDialog(
                  context,
                  'Registration Failed',
                );
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Already have an account? Login'))
        ],
      ),
    );
  }
}
