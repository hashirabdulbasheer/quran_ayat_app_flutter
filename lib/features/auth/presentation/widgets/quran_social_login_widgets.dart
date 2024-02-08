import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import '../../../../misc/configs/remote_config_manager.dart';

class QuranSocialLoginButtons extends StatelessWidget {
  final bool isSignUp;
  final Function onStarted;
  final Function onComplete;

  const QuranSocialLoginButtons({
    Key? key,
    required this.isSignUp,
    required this.onStarted,
    required this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!RemoteConfigManager.instance.isSocialMediaLoginEnabled) {
      return Container();
    }

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
    onStarted();
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    UserCredential credential =
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
    // await FirebaseAuth.instance.signInWithRedirect(googleProvider);
    if(credential.user != null) {
      onComplete();
    }

    return credential;
  }
}
