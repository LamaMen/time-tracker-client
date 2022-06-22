import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController _controller;
  final bool isUserSelected;

  const PasswordField(
      {Key? key,
      required TextEditingController controller,
      required this.isUserSelected})
      : _controller = controller,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      controller: _controller,
      enabled: isUserSelected,
      decoration: InputDecoration(
        hintText: "Пароль",
        fillColor: Colors.white,
        hoverColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.all(1),
        disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFBDBDBD))),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor)),
      ),
    );
  }
}
