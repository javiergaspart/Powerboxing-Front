import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  final Color color;

  const LoadingSpinner({Key? key, this.color = Colors.blue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
