import 'dart:developer' as devtools show log;
import 'package:expense_tracker/constants/routes.dart';
import 'package:expense_tracker/enums/menu-actions.dart';
import 'package:expense_tracker/views/services/auth/auth_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyNotesView extends StatefulWidget {
  const MyNotesView({ Key? key }) : super(key: key);

  @override
  _MyNotesViewState createState() => _MyNotesViewState();
}


class _MyNotesViewState extends State<MyNotesView> {
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
                child: Text("logut")
                )
            ];
            })
        ],
      ),
      body:const Column(
        children: [
           Text("you are logged in!"),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: ()=>{
        
      },
      tooltip: "add your notes",
      child: const Icon(Icons.add),
      ),
      
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