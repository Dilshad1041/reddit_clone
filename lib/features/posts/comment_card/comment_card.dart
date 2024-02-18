import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/models/comment_model.dart';

class CommentCard extends ConsumerWidget {
  final Comments comments;
  const CommentCard({super.key, required this.comments});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(comments.profilePic),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "/u${comments.userName}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(comments.text)
                    ],
                  ),
                ),
              )
            ],
          ),
          Row(children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.reply),
            ),
            const Text('Reply')
          ]),
        ],
      ),
    );
  }
}
