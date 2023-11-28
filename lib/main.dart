import 'package:expense_tracker/constants/routes.dart';
import 'package:expense_tracker/views/login-view.dart';
import 'package:expense_tracker/views/notes/new_note_view.dart';
import 'package:expense_tracker/views/notes/notes_view.dart';
import 'package:expense_tracker/views/register-view.dart';
import 'package:expense_tracker/views/services/auth/auth_service.dart';
import 'package:expense_tracker/views/verify-email-veiw.dart';
import 'package:flutter/material.dart';
// import 'package:path/path.dart';


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
        newNoteRoute:(context)=> const NewNoteView()
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = AuthService.firebase().currentUser;
                if(user != null){

                if(user.isEmailVerified){
                  return const MyNotesView();
                }else{
                  
                  return const VerifyEmailView();
                }
                }else{

                return const LoginView();
                }
                
              default:
                return const Scaffold(body: CircularProgressIndicator());
            }
          });
  }
}


