import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../misc/router/router_utils.dart';
import '../../../models/qr_user_model.dart';
import '../../../utils/utils.dart';
import '../../core/domain/app_state/app_state.dart';
import '../domain/auth_factory.dart';
import 'widgets/quran_social_login_widgets.dart';

class QuranLoginScreen extends StatefulWidget {
  const QuranLoginScreen({super.key});

  @override
  State<QuranLoginScreen> createState() => _QuranLoginScreenState();
}

class _QuranLoginScreenState extends State<QuranLoginScreen> {
  bool _passwordVisible = false;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
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
                autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                enabled: !_isLoading,
                controller: _emailController,
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
                enabled: !_isLoading,
                controller: _passwordController,
                obscureText: !_passwordVisible,
                textInputAction: TextInputAction.done,
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
                    onPressed: () => _passwordVisibilityTogglePressed(),
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
                          if (!_isLoading) {_loginButtonPressed()},
                        },
                        child: _isLoading
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text("Login"),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () => _forgotPasswordButtonPressed(),
                    child: const Text("Forgot Password"),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () => {
                  QuranNavigator.of(context).routeToSignUp().then((value) {
                    if (value != null && value) {
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    }
                  }),
                },
                child: const Text(
                  "Create a new account",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              QuranSocialLoginButtons(
                isSignUp: false,
                onStarted: () => _showLoadingProgress(true),
                onComplete: () => _onLoggedInAction(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLoggedInAction() {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      StoreProvider.of<AppState>(context).dispatch(AppStateInitializeAction());
      Navigator.of(context).pop();
      _showMessage("Logged in 👍");
    }
    _showLoadingProgress(false);
  }

  void _passwordVisibilityTogglePressed() {
    // Update the state i.e. toggle the state of passwordVisible variable
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _loginButtonPressed() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    if (email.isNotEmpty && password.isNotEmpty && QuranUtils.isEmail(email)) {
      _showLoadingProgress(true);
      QuranAuthFactory.engine
          .login(
        email,
        password,
      )
          .then((response) {
        _showLoadingProgress(false);
        if (response.isSuccessful) {
          _onLoggedInAction();
        } else {
          _showMessage("Sorry 😔, ${response.message}");
        }
      });
    } else {
      _showMessage("Sorry 😔, Please enter a valid email and password");
    }
  }

  void _forgotPasswordButtonPressed() async {
    String email = _emailController.text;
    if (email.isNotEmpty && QuranUtils.isEmail(email)) {
      _showLoadingProgress(true);
      QuranAuthFactory.engine.forgotPassword(email).then((response) {
        _showLoadingProgress(false);
        _showMessage(response.message);
      });
    } else {
      _showMessage(
        "Sorry 😔, Please enter a valid email and click forgot password.",
      );
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
