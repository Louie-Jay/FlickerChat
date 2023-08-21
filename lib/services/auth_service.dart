import 'package:firebase_auth/firebase_auth.dart';
import 'package:flickerchat/helper/helper_function.dart';
import 'package:flickerchat/services/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  Future loginUserNameandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;

      if (user != null) {
        return true;
      }
      
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //register
  Future registerUserWithEmailandPassword(String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;

      if (user!=null) {
        // call our db and update user database.
        await DatabaseService(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
      
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //signout
  Future signOut() async {
    try {
            await HelperFunctions.saveUserLoggedInStatus(false);
            await HelperFunctions.saveUserEmailSF("");
            await HelperFunctions.saveUserEmailSF("");
            await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}