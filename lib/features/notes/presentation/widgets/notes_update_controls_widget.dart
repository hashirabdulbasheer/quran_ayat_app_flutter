import 'package:flutter/material.dart';

class QuranUpdateControlsWidget extends StatelessWidget {
  final Function onUpdate;
  final Function onDelete;

  const QuranUpdateControlsWidget({
    Key? key,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () => onUpdate(),
                child: const Text("Update"),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () => onDelete(),
                child: const Text("Delete"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
