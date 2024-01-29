// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolScreen extends StatelessWidget {
  final String name;
  const ModToolScreen({
    Key? key,
    required this.name,
  }) : super(key: key);

  void navigateToEditCommunityScreen(BuildContext context) {
    Routemaster.of(context).push('/edit-community/$name');
  }

  void navigateToAddModScreen(BuildContext context) {
    Routemaster.of(context).push('/add-mod/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mod Tools'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Add Moderator'),
            leading: const Icon(Icons.add_moderator),
            onTap: () =>navigateToAddModScreen(context),
          ),
          ListTile(
            title: const Text('Edit community'),
            leading: const Icon(Icons.edit),
            onTap: () =>navigateToEditCommunityScreen(context)
          )
        ],
      ),
    );
  }
}
