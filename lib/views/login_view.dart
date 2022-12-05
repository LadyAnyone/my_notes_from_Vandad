import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learn_project/constanst/routes.dart';
import 'package:flutter_learn_project/services/auth/auth_exception.dart';
import 'package:flutter_learn_project/services/auth/auth_service.dart';
import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

//init state ve dispose un nasıl ve niye çalıştığını öğreneceğim. neden late ve final kullandığımıız, bunların işleverini,
// nerede kullanılıcapını öğren

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
        title: const Text('Login'),
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
                //await unutma
                await AuthService.firebase()
                    .logIn(email: email, password: password);

                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerify ?? false) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(notesRoute, (route) => false);
                } else {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(verifyRoute, (route) => false);
                }
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(notesRoute, (route) => false);
              } on UserNotFoundAuthException {
                await showErrorDialog(context, 'User not found');
              } on WrongPasswordAuthException {
                await showErrorDialog(context, 'Wrong credentials');
              } on GenericAuthException {
                await showErrorDialog(context, 'Authentication error');
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  await showErrorDialog(
                    context,
                    'User not found',
                  );
                } else if (e.code == 'wrong-password') {
                  await showErrorDialog(
                    context,
                    'Wrong credentails',
                  );
                } else {
                  await showErrorDialog(
                    context,
                    'Error:${e.code}',
                  );
                }
              } catch (e) {
                await showErrorDialog(
                  context,
                  e.toString(),
                );
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text(
              'Not register yet?Register here!',
            ),
          )
        ],
      ),
    );
  }
}
