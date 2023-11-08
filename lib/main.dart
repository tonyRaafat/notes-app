
import 'package:expense_tracker/constants/routes.dart';
import 'package:expense_tracker/views/login-view.dart';
import 'package:expense_tracker/views/note-view.dart';
import 'package:expense_tracker/views/register-view.dart';
import 'package:expense_tracker/views/verify-email-veiw.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
     MaterialApp(
       debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: 'notes app',
      home: const HomePage(),
      routes: {
        loginRoute :(context) =>  const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute:(context)=> const MyNotesView(),
        emailVerificationRoute:(context) => const VerifyEmailView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                if(user != null){

                if(user.emailVerified){
                  return const MyNotesView();
                }else{
                  
                  return const VerifyEmailView();
                }
                }else{

                return const LoginView();
                }
                
              default:
                return Scaffold(body: const CircularProgressIndicator());
            }
          });
  }
}


