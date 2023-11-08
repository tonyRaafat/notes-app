import 'package:expense_tracker/views/services/auth/auth_exceptions.dart';
import 'package:expense_tracker/views/services/auth/auth_provider.dart';
import 'package:expense_tracker/views/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    // TODO: implement createUser

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if(user != null){
        return user;
      }else{
        throw UserNotFoundAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if(e.code == "weak-password"){
        throw WeakPasswordAuthException();
      }else if(e.code == "email-already-in-use"){
        throw EmailAlreadyInAuthException();
      }else if(e.code == "invalid-email"){
        throw InvalidEmailAuthException();
      }else{
        throw GenericAuthException();
      }
    } catch (_) {
        throw GenericAuthException();
    }
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> login({required String email, required String password})async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if(user != null){
        return user;
      }else{
        throw UserNotFoundAuthException();
      }
    }on FirebaseAuthException catch(e){
      if(e.code == "user-not-found"){
        throw UserNotFoundAuthException();
      }else if(e.code == "wrong-password"){
        throw WeakPasswordAuthException();
      }else{
        throw GenericAuthException();
      }
    }catch(_){
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logout() async{
    // TODO: implement logout
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      await FirebaseAuth.instance.signOut();
    }else{
      throw UserNotLoggedInAuthException();
    }
    
  }

  @override
  Future<void> sendEmailVerification() async {
    if(currentUser != null){
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
    }else{
      throw UserNotLoggedInAuthException();
    }
  }
}
