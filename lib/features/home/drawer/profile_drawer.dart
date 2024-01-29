import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/auth/contollers/auth_controller.dart';
import 'package:reddit/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void navigateToProfileScreen(String uid, BuildContext context) {
    Routemaster.of(context).push('/u/$uid');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTeme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return SafeArea(
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.profilePic),
            radius: 70,
          ),
          Text(
            'u/${user.name}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.person,
            ),
            title: const Text('My Profile'),
            onTap: () => navigateToProfileScreen(user.uid, context),
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Pallete.redColor,
            ),
            title: const Text('Logout'),
            onTap: () => logOut(ref),
          ),
          Switch.adaptive(
            value: ref.watch(themeNotifierProvider.notifier).mode ==
                ThemeMode.dark,
            onChanged: (val) => toggleTheme(ref),
          ),
        ],
      ),
    );
  }
}
