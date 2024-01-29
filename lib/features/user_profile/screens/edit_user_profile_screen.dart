import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/auth/contollers/auth_controller.dart';
import 'package:reddit/features/user_profile/controllers/user_profile_controller.dart';
import 'package:reddit/theme/pallete.dart';

class EditUserProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditUserProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends ConsumerState<EditUserProfileScreen> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController = TextEditingController();
  

  @override
  void initState() {
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editProfile(
        profileFile: profileFile,
        name: nameController.text.trim(),
        bannerFile: bannerFile,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(userProfileControllerProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when(
          data: (user) => Scaffold(
            backgroundColor:currentTheme.canvasColor,
            appBar: AppBar(
              title: const Text('Edit Profile'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: save,
                  child: const Text('Save'),
                ),
              ],
            ),
            body: isLoading
                ? const Loader()
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: selectBannerImage,
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(10),
                                  dashPattern: const [10, 4],
                                  strokeCap: StrokeCap.round,
                                  color: currentTheme.textTheme
                                      .bodyLarge!.color!,
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: bannerFile != null
                                        ? Image.file(bannerFile!)
                                        : user.banner.isEmpty ||
                                                user.banner ==
                                                    Constants.bannerDefault
                                            ? const Center(
                                                child: Icon(
                                                  Icons.camera_alt_outlined,
                                                  size: 40,
                                                ),
                                              )
                                            : Image.network(user.banner),
                                  ),
                                ),
                              ),
                              Positioned(
                                  bottom: 20,
                                  left: 20,
                                  child: GestureDetector(
                                    onTap: selectProfileImage,
                                    child: profileFile != null
                                        ? CircleAvatar(
                                            radius: 32,
                                            backgroundImage:
                                                FileImage(profileFile!),
                                          )
                                        : CircleAvatar(
                                            radius: 32,
                                            backgroundImage:
                                                NetworkImage(user.profilePic),
                                          ),
                                  ))
                            ],
                          ),
                        ),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'Name',
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.blue,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(18),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          loading: () => const Loader(),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
        );
  }
}
