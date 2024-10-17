import 'package:flutter/material.dart';

class UserErrorPage extends StatelessWidget {
  const UserErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text("An error occured"),
      ),
    );
  }
}
