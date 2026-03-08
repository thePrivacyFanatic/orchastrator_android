import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  const PasswordFormField(
      {super.key, this.controller, this.validator, this.onSaved});

  @override
  State<PasswordFormField> createState() {
    return _PasswordFieldState();
  }
}

class _PasswordFieldState extends State<PasswordFormField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password',
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          )),
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: !_passwordVisible,
      enableSuggestions: false,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}
