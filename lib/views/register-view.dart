import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  hintText: "Email", contentPadding: EdgeInsets.only(left: 10)),
            ),
            TextField(
              controller: _pass,
              obscureText: true,
              autocorrect: true,
              decoration: const InputDecoration(
                hintText: 'Password',
                contentPadding: EdgeInsets.only(left: 10),
              ),
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final pass = _pass.text;
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: pass);
                print(userCredential);
              },
              child: const Text("Register"),
            ),
            TextButton(
                onPressed: () => {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login/', (route) => false)
                    },
                child: const Text('Login here!')),
          ],
        ),
      ),
    );
  }
}
