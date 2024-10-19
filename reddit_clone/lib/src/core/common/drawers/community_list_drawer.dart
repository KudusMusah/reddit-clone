import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends StatelessWidget {
  const CommunityListDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text('Create a community'),
              leading: const Icon(Icons.add),
              onTap: () {
                Routemaster.of(context).push("create-community");
              },
            ),
          ],
        ),
      ),
    );
  }
}
