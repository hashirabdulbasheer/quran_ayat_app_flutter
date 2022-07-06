import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/qr_response_model.dart';
import '../../../models/qr_user_model.dart';
import '../domain/interfaces/quran_auth_interface.dart';

class QuranFirebaseAuthEngine implements QuranAuthInterface {
  @override
  Future<QuranResponse> login(String username, String password) async {
    try {
      final _ = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: username, password: password);
      return QuranResponse(isSuccessful: true, message: "Logged In 👍");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return QuranResponse(
            isSuccessful: false, message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return QuranResponse(
            isSuccessful: false,
            message: 'Wrong password provided for that user.');
      }
    }
    return QuranResponse(isSuccessful: false, message: "Error creating user");
  }

  @override
  Future<QuranResponse> signup(
      String name, String username, String password) async {
    try {
      var credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: username,
        password: password,
      );
      await credential.user?.updateDisplayName(name);
      return QuranResponse(
          isSuccessful: true, message: "Successfully created user 👍");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return QuranResponse(
            isSuccessful: false, message: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return QuranResponse(
            isSuccessful: false,
            message: "The account already exists for that email.");
      }
    } catch (e) {
      print(e);
    }
    return QuranResponse(isSuccessful: false, message: "Error creating user");
  }

  @override
  Future<QuranUser?> getUser() async {
    await FirebaseAuth.instance.currentUser?.reload();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String name = user.displayName ?? "";
      String email = user.email ?? "";
      String uid = user.uid;
      if (name.isNotEmpty && email.isNotEmpty) {
        QuranUser quranUser = QuranUser(name: name, email: email, uid: uid);
        return quranUser;
      }
    }
    return null;
  }

  @override
  Future<QuranResponse> logout() async {
    await FirebaseAuth.instance.signOut();
    return QuranResponse(
        isSuccessful: true, message: "Successfully signed out 👍");
  }

  @override
  Future<QuranResponse> update(String name) async {
    await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
    return QuranResponse(
        isSuccessful: true, message: "Successfully updated user 👍");
  }

  @override
  Future<QuranResponse> forgotPassword(String email) async {
    return await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) => QuranResponse(
            isSuccessful: true, message: "Done 👍, please check your email."))
        .catchError((e) => QuranResponse(
            isSuccessful: false, message: "Sorry 😔, ${e.toString()}."));
  }
}
