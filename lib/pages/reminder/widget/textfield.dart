
import 'package:flutter/material.dart';

class ReminderTextField extends StatelessWidget {
  const ReminderTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.errorMessage,
    required this.keyboardType
  });

  final TextEditingController controller;
  final String errorMessage;
  final TextInputType keyboardType;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: 1,
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty? errorMessage :null,
      decoration:  InputDecoration(
        contentPadding: const EdgeInsets.all(8),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      controller: controller,
    );
  }
}