import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../firebase_options.dart';
import '../../../models/qr_response_model.dart';
import '../../../models/qr_user_model.dart';
import '../domain/interfaces/quran_auth_interface.dart';

/// Singleton
class QuranFirebaseAuthEngine implements QuranAuthInterface {
  QuranFirebaseAuthEngine._privateConstructor();

  static final QuranFirebaseAuthEngine instance =
      QuranFirebaseAuthEngine._privateConstructor();

  QuranUser? _user;

  List<Function> authChangeListeners = [];

  _authChangeListener(User? user) {
    _user = _mapFirebaseUserToQuranUser(user);
    // inform all of auth change
    for (Function listener in authChangeListeners) {
      listener();
    }
  }

  /// User? -> QuranUser?
  QuranUser? _mapFirebaseUserToQuranUser(User? user) {
    if (user != null) {
      String name = user.displayName ?? "";
      String email = user.email ?? "";
      String uid = user.uid;
      if (name.isNotEmpty && email.isNotEmpty && uid.isNotEmpty) {
        return QuranUser(name: name, email: email, uid: uid);
      }
    }
    return null;
  }

  @override
  Future<bool> initialize() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseAuth.instance.authStateChanges().listen(_authChangeListener);
    return true;
  }

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
    return QuranResponse(isSuccessful: false, message: "Error logging in");
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
  QuranUser? getUser() {
    if (_user != null) {
      return _user;
    }
    FirebaseAuth.instance.currentUser?.reload();
    User? user = FirebaseAuth.instance.currentUser;
    _user = _mapFirebaseUserToQuranUser(user);
    return _user;
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

  @override
  void registerAuthChangeListener(Function listener) {
    authChangeListeners.add(listener);
  }

  @override
  void unregisterAuthChangeListener(Function listener) {
    authChangeListeners.remove(listener);
  }
}
