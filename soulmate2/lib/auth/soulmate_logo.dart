import 'package:flutter/material.dart';

class SoulmateLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Soulmate',
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 56,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
