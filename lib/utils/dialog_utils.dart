import 'package:flutter/material.dart';

class DialogUtils {
  static Future<void> confirmationDialog(
    BuildContext context,
    String title,
    String message,
    String actionButtonText,
    Function onConfirmation,
  ) async {
    return showDialog(
      context: context,
      builder: (
        context,
      ) {
        return AlertDialog(
          title: Text(
            title,
          ),
          content: Text(
            message,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            MaterialButton(
              color: Colors.blueGrey,
              textColor: Colors.white,
              child: Text(
                actionButtonText,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () => {
                Navigator.of(context).pop(),
                onConfirmation(),
              },
            ),
          ],
        );
      },
    );
  }
}
