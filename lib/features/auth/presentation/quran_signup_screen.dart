import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/qr_user_model.dart';
import '../../../utils/utils.dart';
import '../domain/auth_factory.dart';
import 'widgets/quran_social_login_widgets.dart';

class QuranSignUpScreen extends StatefulWidget {
  const QuranSignUpScreen({Key? key}) : super(key: key);

  @override
  State<QuranSignUpScreen> createState() => _QuranSignUpScreenState();
}

class _QuranSignUpScreenState extends State<QuranSignUpScreen> {
  bool _passwordVisible = false;
  bool _isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          30,
          20,
          30,
          20,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nameController,
                enabled: !_isLoading,
                autofillHints: const [
                  AutofillHints.name,
                  AutofillHints.username,
                  AutofillHints.creditCardName,
                  AutofillHints.givenName,
                ],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Name',
                  labelText: 'Name',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _emailController,
                enabled: !_isLoading,
                autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _passwordController,
                keyboardType: TextInputType.text,
                obscureText: !_passwordVisible,
                enabled: !_isLoading,
                textInputAction: TextInputAction.go,
                decoration: InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () => {
                      // Update the state i.e. toggle the state of passwordVisible variable
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      }),
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => {
                          if (!_isLoading) {_signUpButtonPressed()},
                        },
                        child: _isLoading
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text("Sign Up"),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              QuranSocialLoginButtons(
                isSignUp: true,
                onStarted: () => _showLoadingProgress(true),
                onComplete: () => _onSignedUpAction(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSignedUpAction() {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      Navigator.of(context).pop(true);
      _showMessage("Success 👍. Ahlan wa sahlan!");
    }
    _showLoadingProgress(false);
  }

  Future<UserCredential?> signInWithGoogle() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    await FirebaseAuth.instance.signInWithPopup(googleProvider);
    await FirebaseAuth.instance.signInWithRedirect(googleProvider);

    return await FirebaseAuth.instance.getRedirectResult();
  }

  void _signUpButtonPressed() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    if (name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        QuranUtils.isEmail(email)) {
      _showLoadingProgress(true);
      QuranAuthFactory.engine
          .signup(
        name,
        email,
        password,
      )
          .then((response) {
        _showLoadingProgress(false);
        if (response.isSuccessful) {
          _onSignedUpAction();
        } else {
          _showMessage("Sorry 😔, ${response.message}");
        }
      });
    } else {
      _showMessage("Sorry 😔, please fill in all fields correctly");
    }
  }

  void _showLoadingProgress(bool status) {
    setState(() {
      _isLoading = status;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
