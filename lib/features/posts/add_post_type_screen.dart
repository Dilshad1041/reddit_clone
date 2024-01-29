import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/community/controllers/community_controller.dart';
import 'package:reddit/features/posts/controllers/post_controller.dart';
import 'package:reddit/models/community_model.dart';
import 'package:reddit/theme/pallete.dart';

class AddPoastTypeScreen extends ConsumerStatefulWidget {
  const AddPoastTypeScreen({super.key, required this.type});
  final String type;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPoastTypeScreenState();
}

class _AddPoastTypeScreenState extends ConsumerState<AddPoastTypeScreen> {
  File? bannerFile;
  final titleController = TextEditingController();
  final textController = TextEditingController();
  final linkController = TextEditingController();
  List<Community> communities = [];
  Community? selectedCommunity;
  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    textController.dispose();
    linkController.dispose();
  }

  void sharePost() {
    if (widget.type == 'image' &&
        bannerFile != null &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          file: bannerFile);
    } else if (widget.type == 'text' && textController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          description: textController.text.trim());
    } else if (widget.type == 'link' &&
        titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          link: linkController.text.trim());
    } else {
      showSnackBar(context, 'Please fill all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(postControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        actions: [
          TextButton(
            onPressed: sharePost,
            child: const Text('Share'),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: 'Enter Title Here',
                        filled: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10)),
                    maxLength: 30,
                  ),
                ),
                if (isTypeImage)
                  GestureDetector(
                    onTap: selectBannerImage,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(10),
                      dashPattern: const [10, 4],
                      strokeCap: StrokeCap.round,
                      color: currentTheme.textTheme.bodyLarge!.color!,
                      child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: bannerFile != null
                              ? Image.file(bannerFile!)
                              : const Center(
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 40,
                                  ),
                                )),
                    ),
                  ),
                if (isTypeText)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        hintText: 'Enter description Here',
                        filled: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                      ),
                      maxLines: 5,
                    ),
                  ),
                if (isTypeLink)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: linkController,
                      decoration: const InputDecoration(
                        hintText: 'Enter link Here',
                        filled: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text('Select Community'),
                ),
                ref.watch(getUserCommunityProvider).when(
                    data: (data) {
                      communities = data;
                      if (communities.isEmpty) {
                        return const SizedBox();
                      }
                      return DropdownButton(
                          value: selectedCommunity ?? data[0],
                          items: data
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.name),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedCommunity = val;
                            });
                          });
                    },
                    error: (error, stackTrace) => ErrorText(
                          error: error.toString(),
                        ),
                    loading: () => const Loader())
              ],
            ),
    );
  }
}
