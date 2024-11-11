import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  final String title;
  final String routeName;

  const NavigationButton({required this.title, required this.routeName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
