import 'package:expense_tracker/constants/routes.dart';
import 'package:expense_tracker/views/services/auth/auth_exceptions.dart';
import 'package:expense_tracker/views/services/auth/auth_service.dart';
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
  String? emailError ;
  String? passError ;

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
                
                decoration:  InputDecoration(
                    hintText: "email@gmail.com",
                    focusedBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                    label:  Text('email'),
                    contentPadding: EdgeInsets.only(left: 10),
                    errorText: emailError,
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
                decoration:  InputDecoration(
                    label: Text(
                      'password',
                      selectionColor: Color.fromARGB(0, 196, 36, 36),
                    ),
                    focusedBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                    hintText: "pass",
                    contentPadding: EdgeInsets.only(left: 10),
                    errorText: passError,
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
                            final password = _pass.text;
                            try  {
                              await AuthService.firebase().login(email: email, password: password);
                              
                              final user = AuthService.firebase().currentUser;
                              if (user?.isEmailVerified ?? false) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    notesRoute, (route) => false);
                              } else {
                                Navigator.of(context)
                                    .pushNamed(emailVerificationRoute);
                              }
                            } on InvalidEmailAuthException catch (e) {
                                emailError = "Invalid email";
                              setState(() {
                              });
                            } on WrongPasswordAuthException catch (e){
                              setState(() {
                                passError = "worng password";
                              });
                            }on GenericAuthException catch (e) {
                              setState(() {
                                emailError = "somthing is wrong";
                              });
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
