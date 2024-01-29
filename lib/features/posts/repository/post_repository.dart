import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/providers/firebase_providers.dart';
import 'package:reddit/core/type_def.dart';
import 'package:reddit/models/community_model.dart';
import 'package:reddit/models/post_model.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.read(fireStroreProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  CollectionReference get _post =>
      _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_post.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    return _post
        .where('communityName',
            whereIn: communities.map((e) => e.name).toList())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(
        _post.doc(post.id).delete(),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  void upVote(Post post, String UserId) {
    if (post.downvotes.contains(UserId)) {
      _post.doc(post.id).update(
        {
          'downvotes': FieldValue.arrayRemove(
            [UserId],
          ),
        },
      );
    }
    if (post.upvotes.contains(UserId)) {
      _post.doc(post.id).update(
        {
          'upvotes': FieldValue.arrayRemove(
            [UserId],
          ),
        },
      );
    } else {
      _post.doc(post.id).update(
        {
          'upvotes': FieldValue.arrayUnion(
            [UserId],
          ),
        },
      );
    }
  }

  void downVote(Post post, String UserId) {
    if (post.upvotes.contains(UserId)) {
      _post.doc(post.id).update(
        {
          'upvotes': FieldValue.arrayRemove(
            [UserId],
          ),
        },
      );
    }
    if (post.downvotes.contains(UserId)) {
      _post.doc(post.id).update(
        {
          'downvotes': FieldValue.arrayRemove(
            [UserId],
          ),
        },
      );
    } else {
      _post.doc(post.id).update(
        {
          'downvotes': FieldValue.arrayUnion(
            [UserId],
          ),
        },
      );
    }
  }

  Stream<Post> getPostById(String postID) {
    return _post.doc(postID).snapshots().map(
          (event) => Post.fromMap(event.data() as Map<String, dynamic>),
        );
  }
}
