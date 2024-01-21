import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class QuranSocialLoginButtons extends StatelessWidget {
  final bool isSignUp;

  const QuranSocialLoginButtons({
    Key? key,
    required this.isSignUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 2,
          shadowColor: Colors.grey,
          child: SocialLoginButton(
            text: isSignUp ? "Sign Up with Google" : "Sign In with Google",
            buttonType: SocialLoginButtonType.google,
            onPressed: () => signInWithGoogle(),
          ),
        ),
      ],
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    UserCredential _ =
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
    await FirebaseAuth.instance.signInWithRedirect(googleProvider);

    return await FirebaseAuth.instance.getRedirectResult();
  }
}
