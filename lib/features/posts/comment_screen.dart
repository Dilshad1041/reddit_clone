import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/common/post_card.dart';
import 'package:reddit/features/posts/comment_card/comment_card.dart';
import 'package:reddit/features/posts/controllers/post_controller.dart';
import 'package:reddit/models/post_model.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String postId;

  const CommentScreen({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComments(
          text: commentController.text.trim(),
          context: context,
          post: post,
        );

    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (data) {
              return Column(
                children: [
                  PostCard(post: data),
                  TextField(
                    onSubmitted: (val) => addComment(data),
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: "What are your thoughts",
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                  Expanded(
                    child:
                        ref.watch(getCommentByPostProvider(widget.postId)).when(
                              data: (data) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  itemBuilder: ((context, index) {
                                    final comment = data[index];
                                    return CommentCard(comments: comment);
                                  }),
                                );
                              },
                              error: (error, stackTrace) {
                                print(error.toString());
                                return ErrorText(
                                  error: error.toString(),
                                );
                              },
                              loading: () => const Loader(),
                            ),
                  ),
                ],
              );
            },
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}
