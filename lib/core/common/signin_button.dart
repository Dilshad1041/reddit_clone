import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/features/auth/contollers/auth_controller.dart';
import 'package:reddit/theme/pallete.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({super.key});

  void signInWithGoogle(WidgetRef ref,BuildContext context){
      ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () =>signInWithGoogle(ref,context),
        icon: Image.asset(
          Constants.googlePath,
          width: 35,
        ),
        label: const Text(
          'Continue with Google',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          maximumSize: const Size(double.infinity, 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
