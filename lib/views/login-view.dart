import 'package:firebase_auth/firebase_auth.dart';
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
          title: const Text(
        'Login',
      )),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            TextField(
              enableInteractiveSelection: true,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  hintText: "email", contentPadding: EdgeInsets.only(left: 10)),
            ),
            TextField(
              controller: _pass,
              obscureText: true,
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: "pass", contentPadding: EdgeInsets.only(left: 10)),
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
                    child: const Text("Login"))),
            Center(
              child: TextButton(
                onPressed: () => {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/register/', (route) => false)
                        },
                child: const Text("have registered yet? register here!"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
