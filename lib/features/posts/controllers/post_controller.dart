import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/providers/storage_repository_provider.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/auth/contollers/auth_controller.dart';
import 'package:reddit/features/posts/repository/post_repository.dart';
import 'package:reddit/models/comment_model.dart';
import 'package:reddit/models/community_model.dart';
import 'package:reddit/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storegeRepository = ref.watch(storegeRepositoryProvider);
  return PostController(
      postRepository: postRepository,
      storegeRepository: storegeRepository,
      ref: ref);
});

final userPostProvider =
    StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
});

final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  return ref.watch(postControllerProvider.notifier).getPostById(postId);
});

final getCommentByPostProvider = StreamProvider.family((ref, String postId) {
  return ref.read(postControllerProvider.notifier).getCommentByPost(postId);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final StoregeRepository _storegeRepository;
  final Ref _ref;

  PostController({
    required PostRepository postRepository,
    required StoregeRepository storegeRepository,
    required Ref ref,
  })  : _postRepository = postRepository,
        _ref = ref,
        _storegeRepository = storegeRepository,
        super(false);

  void shareText(
      {required BuildContext context,
      required String title,
      required Community selectedCommunity,
      required String description}) async {
    state = true;
    final postID = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
        id: postID,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'text',
        createdAt: DateTime.now(),
        awards: [],
        description: description);

    final res = await _postRepository.addPost(post);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted succesfully');
      Routemaster.of(context).pop();
    });
  }

  void shareTextPost(
      {required BuildContext context,
      required String title,
      required Community selectedCommunity,
      required String description}) async {
    state = true;
    final postID = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
        id: postID,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'text',
        createdAt: DateTime.now(),
        awards: [],
        description: description);

    final res = await _postRepository.addPost(post);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted succesfully');
      Routemaster.of(context).pop();
    });
  }

  void shareLinkPost(
      {required BuildContext context,
      required String title,
      required Community selectedCommunity,
      required String link}) async {
    state = true;
    final postID = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
        id: postID,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'link',
        createdAt: DateTime.now(),
        awards: [],
        link: link);

    final res = await _postRepository.addPost(post);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted succesfully');
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost(
      {required BuildContext context,
      required String title,
      required Community selectedCommunity,
      required File? file}) async {
    state = true;
    final postID = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final imageRes = await _storegeRepository.storeFile(
      path: '/posts${selectedCommunity.name}',
      id: postID,
      file: file,
    );

    imageRes.fold((l) => showSnackBar(context, l.message), (r) async {
      final Post post = Post(
          id: postID,
          title: title,
          communityName: selectedCommunity.name,
          communityProfilePic: selectedCommunity.avatar,
          upvotes: [],
          downvotes: [],
          commentCount: 0,
          username: user.name,
          uid: user.uid,
          type: 'image',
          createdAt: DateTime.now(),
          awards: [],
          link: r);

      final res = await _postRepository.addPost(post);
      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Posted succesfully');
        Routemaster.of(context).pop();
      });
    });
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    }
    return Stream.value([]);
  }

  void deletePost(Post post) async {
    final res = await _postRepository.deletePost(post);
    res.fold((l) => null, (r) => null);
  }

  void upVote(Post post) {
    final userId = _ref.read(userProvider)!.uid;
    _postRepository.upVote(post, userId);
  }

  void downVote(Post post) {
    final userId = _ref.read(userProvider)!.uid;
    _postRepository.downVote(post, userId);
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  void addComments(
      {required String text,
      required BuildContext context,
      required Post post}) async {
    final user = _ref.read(userProvider)!;
    final commentId = const Uuid().v1();
    Comments comments = Comments(
        id: commentId,
        text: text,
        createdAt: DateTime.now(),
        postId: post.id,
        userName: user.name,
        profilePic: user.profilePic);
    final res = await _postRepository.addComments(comments);
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  Stream<List<Comments>> getCommentByPost(String postId) {
    return _postRepository.getCommentByPost(postId);
  }
}
