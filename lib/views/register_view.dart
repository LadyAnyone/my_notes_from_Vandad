import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learn_project/constanst/routes.dart';
import 'package:flutter_learn_project/services/auth/auth_exception.dart';
import 'package:flutter_learn_project/services/auth/auth_service.dart';

import '../utilities/show_error_dialog.dart';

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
            autocorrect: false, //otomatik düzeltme
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false, //öneriler
            autocorrect: false, //otomatik düzeltme
            decoration:
                const InputDecoration(hintText: 'Enter yours password here'),
          ),
          TextButton(
            onPressed: () async {
              //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase()
                    .createUser(email: email, password: password);
                AuthService.firebase().sendEmailVerification();

                Navigator.of(context).pushNamed(verifyRoute);
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(context, 'Email is already in use');
              } on InvalidEmailAuthException {
                showErrorDialog(context, 'This is invalid amail address');
              } on GenericAuthException catch (e) {
                await showErrorDialog(context, 'Failed to register.');
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Already registered? Login Here!'))
        ],
      ),
    );
  }
}
