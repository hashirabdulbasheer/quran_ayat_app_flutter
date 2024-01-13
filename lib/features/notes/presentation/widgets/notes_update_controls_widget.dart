import 'package:flutter/material.dart';

class QuranUpdateControlsWidget extends StatelessWidget {
  final Function onUpdate;
  final Function onDelete;
  final bool? isDeleteLoading;
  final bool? isUpdateLoading;

  const QuranUpdateControlsWidget({
    Key? key,
    required this.onUpdate,
    required this.onDelete,
    this.isDeleteLoading = false,
    this.isUpdateLoading = false,
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
                child: isUpdateLoading == true
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text("Update"),
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => onDelete(),
                child: isDeleteLoading == true
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text("Delete"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
