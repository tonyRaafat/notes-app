import 'package:expense_tracker/constants/routes.dart';
import 'package:expense_tracker/enums/menu-actions.dart';
import 'package:expense_tracker/views/services/auth/auth_service.dart';
import 'package:expense_tracker/views/services/crud/notes_services.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyNotesView extends StatefulWidget {
  const MyNotesView({ Key? key }) : super(key: key);
  @override
  _MyNotesViewState createState() => _MyNotesViewState();
}


class _MyNotesViewState extends State<MyNotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Your notes"),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch(value){
                case MenuAction.logout :
                  final shouldLogout = await showLogoutDialog(context);
                  if(shouldLogout){
                    AuthService.firebase().logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context)
          {
            return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text("logout")
                )
            ];
            })
        ],
      ),
      body:FutureBuilder(future: _notesService.getOrCreateUser(email: userEmail), 
           builder: (context,snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.done:
                  return StreamBuilder(
                   stream: _notesService.allNotes,
                   builder: ((context, snapshot) {
                     switch(snapshot.connectionState){
                       case ConnectionState.waiting:
                         return const Center(child: Text('waiting for all notes'));
                       default:
                          return  const Center(child: CircularProgressIndicator()); 
                     }
                   }));
                default:
                  return  const Center(child: CircularProgressIndicator());
              }
           }
           )
      
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context){
  return showDialog<bool>(
   context: context,
   builder: (context) {
     return AlertDialog(
      title:const Text("Sign out"),
      content:const Text("Are you sure you want to sign out?") ,
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop(true);
        }, child: const Text("Log out")
        ),
        TextButton(onPressed: (){
          Navigator.of(context).pop(false);
        }, child: const Text("Cancel")
        )
      ],
    );
    }
  ).then((value) => value??false);
}