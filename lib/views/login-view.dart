import 'package:expense_tracker/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _pass;
  bool badPass = false;

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
        padding: const EdgeInsets.all(5),
        child: ListView(
         
          children: [
            const SizedBox(
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                enableInteractiveSelection: true,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: "email@gmail.com",
                    focusedBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                    label:  Text('email'),
                    contentPadding: EdgeInsets.only(left: 10)
                    ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: TextField(
                enableInteractiveSelection: true,
                controller: _pass,
                obscureText: true,
                autofillHints:const [AutofillHints.password],
                decoration: const InputDecoration(
                    label: Text(
                      'password',
                      selectionColor: Color.fromARGB(0, 196, 36, 36),
                    ),
                    focusedBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                    hintText: "pass",
                    contentPadding: EdgeInsets.only(left: 10)
                    ),
              ),
            ),
            Row(
              children: [
                Expanded(
                    
                    child: Container(
                      margin: EdgeInsets.fromLTRB(7,5,7,0),
                      child: ElevatedButton(
                          
                          onPressed: () async {
                            final email = _email.text;
                            final pass = _pass.text;
                            try {
                              final userCredential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email, password: pass);
                              devtools.log(userCredential.toString());
                              final user = FirebaseAuth.instance.currentUser;
                              if (user?.emailVerified ?? false) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    notesRoute, (route) => false);
                              } else {
                                Navigator.of(context)
                                    .pushNamed(emailVerificationRoute);
                              }
                            } on FirebaseAuthException catch (e) {
                              devtools.log(e.code.toString());
                            }
                          },
                          child: const Text("Login")
                          ),
                    )
                        ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("have registered yet?"),
                TextButton(
                  onPressed: () => {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(registerRoute, (route) => false)
                  },
                  child: const Text("register here!"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
