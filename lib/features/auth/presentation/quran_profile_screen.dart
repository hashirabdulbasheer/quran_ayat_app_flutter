import 'package:flutter/material.dart';
import '../../bookmark/domain/bookmarks_manager.dart';
import '../domain/auth_factory.dart';
import '../../../models/qr_response_model.dart';
import '../../../models/qr_user_model.dart';

class QuranProfileScreen extends StatefulWidget {
  final QuranUser user;

  const QuranProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<QuranProfileScreen> createState() => _QuranProfileScreenState();
}

class _QuranProfileScreenState extends State<QuranProfileScreen> {
  bool _isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _emailController.text = widget.user.email;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: Directionality(
          textDirection: TextDirection.ltr,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _nameController,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          hintText: 'Name', labelText: 'Name'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _emailController,
                      enabled: false,
                      style: const TextStyle(color: Colors.black54),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          hintText: 'Email', labelText: 'Email'),
                    ),
                    const SizedBox(
                      height: 20,
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
                                onPressed: () {
                                  if (!_isLoading) {
                                    _updateButtonPressed();
                                  }
                                },
                                child: _isLoading
                                    ? const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text("Update")),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextButton(
                        onPressed: () {
                          _signOutButtonPressed().then((value) {
                            Navigator.of(context).pop();
                          });
                        },
                        child: const Text("Sign Out"))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _updateButtonPressed() async {
    _showLoadingProgress(true);
    String newName = _nameController.text;
    if (newName.isNotEmpty) {
      QuranResponse response = await QuranAuthFactory.engine.update(newName);
      _showLoadingProgress(false);
      if (response.isSuccessful) {
        _showMessage("Updated successfully 👍");
      } else {
        _showMessage("Sorry 😔, ${response.message}");
      }
    }
  }

  _signOutButtonPressed() async {
    QuranResponse _ = await QuranAuthFactory.engine.logout();
    // clear stored data
    QuranBookmarksManager.instance.clearLocal();
    return true;
  }

  _showLoadingProgress(bool status) {
    setState(() {
      _isLoading = status;
    });
  }

  _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
