import 'package:expense_tracker/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devTools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: const Text("Register")),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            const SizedBox(height: 200,),
            Container(
              margin: EdgeInsets.all(8),
              child: TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: "email@gmail.com",
                    focusedBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                    label: Text('email'),
                    contentPadding: EdgeInsets.only(left: 10)),
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              child: TextField(
                controller: _pass,
                obscureText: true,
                autofillHints: const [AutofillHints.password],
                decoration: const InputDecoration(
                    label: Text(
                      'password',
                      selectionColor: Color.fromARGB(0, 196, 36, 36),
                    ),
                    focusedBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                    hintText: "pass",
                    contentPadding: EdgeInsets.only(left: 10)),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(7, 5, 7, 0),
                    child: ElevatedButton(
                      onPressed: () async {
                        final email = _email.text;
                        final pass = _pass.text;
                        try {
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: pass);
                          Navigator.of(context)
                              .pushNamed(emailVerificationRoute);
                        } on FirebaseAuthException catch (e) {
                          devTools.log(e.code.toString());
                        }
                      },
                      child: const Text("Register"),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                    onPressed: () => {
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil(loginRoute, (route) => false)
                        },
                    child: const Text('Login here!')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
