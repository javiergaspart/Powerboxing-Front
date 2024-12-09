import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final String title;
  final List<Widget> actions;

  const Navbar({
    Key? key,
    required this.title,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
    );
  }
}
