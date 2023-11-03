import 'package:expense_tracker/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _pass;

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _pass = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: const Color.fromARGB(255, 24, 23, 29),
          title: const Text('Login'),
      ),
      body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
                  children: [
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: "email",
                          contentPadding: EdgeInsets.only(left: 10)),
                    ),
                    TextField(
                      controller: _pass,
                      obscureText: true,
                      autocorrect: false,
                      decoration: const InputDecoration(
                          hintText: "pass",
                          contentPadding: EdgeInsets.only(left: 10)),
                    ),
                    Center(
                        child: TextButton(
                            onPressed: () async {
                              final email = _email.text;
                              final pass = _pass.text;
                              try {
                                final userCredential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: email, password: pass);
                              } on FirebaseAuthException catch (e) {
                                print(e.code);
                              }
                            },
                            child: const Text("Login")))
                  ],
                );
              default:
                return const Text("loading...");
            }
          }),
    );
  }
}
