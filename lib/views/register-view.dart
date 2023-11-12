import 'package:expense_tracker/constants/routes.dart';
import 'package:expense_tracker/views/services/auth/auth_exceptions.dart';
import 'package:expense_tracker/views/services/auth/auth_service.dart';
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
  String? emailError;
  String? passError;

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
        child: ListView(
          children: [
            const SizedBox(height: 150,),
            Container(
              margin: EdgeInsets.all(8),
              child: TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration:  InputDecoration(
                    hintText: "email@gmail.com",
                    focusedBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                    label: Text('email'),
                    contentPadding: EdgeInsets.only(left: 10),
                    errorText: emailError,
                    ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              child: TextField(
                controller: _pass,
                obscureText: true,
                autofillHints: const [AutofillHints.password],
                decoration:  InputDecoration(
                    label: const Text(
                      'password',
                      selectionColor: Color.fromARGB(0, 196, 36, 36),
                    ),
                    focusedBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                    hintText: "pass",
                    contentPadding: EdgeInsets.only(left: 10),
                    errorText: passError
                    ),
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
                        final password = _pass.text;
                        try {
                          setState(() {
                            emailError = null;
                            passError = null;
                          });
                          await AuthService.firebase().createUser(email: email, password: password);
                          Navigator.of(context).pushNamed(emailVerificationRoute);
                        }on GenericAuthException catch (e) {
                          setState(() {
                          });
                        } on InvalidEmailAuthException catch (e){
                            emailError = "Invalid email";
                          setState(() {
                          });
                        } on WeakPasswordAuthException catch (e){
                            passError = "weak password";
                          setState(() {
                          });
                        } on EmailAlreadyInAuthException catch (e) {
                            emailError = "Email already in use";
                          setState(() {
                          });
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
