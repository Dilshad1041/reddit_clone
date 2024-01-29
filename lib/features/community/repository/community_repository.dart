import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/providers/firebase_providers.dart';
import 'package:reddit/core/type_def.dart';
import 'package:reddit/models/community_model.dart';
import 'package:reddit/models/post_model.dart';

final communityRepositoryProvider = Provider((ref) {
  return CommunityRepository(firestore: ref.read(fireStroreProvider));
});

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _communities.doc(community.name).get();
      if (communityDoc.exists) {
        throw 'community name exist';
      }

      right(
        _communities.doc(community.name).set(
              community.toMap(),
            ),
      );
    } on FirebaseException catch (e) {
      left(
        Failure(e.message!),
      );
    } catch (e) {
      left(
        Failure(e.toString()),
      );
    }
    return right(unit);
  }

  Stream<List<Community>> getUserCommunity(String uid) {
    return _communities.where('members', arrayContains: uid).snapshots().map(
      (event) {
        List<Community> communities = [];
        for (var doc in event.docs) {
          communities.add(
            Community.fromMap(doc.data() as Map<String, dynamic>),
          );
        }
        return communities;
      },
    );
  }

  Stream<Community> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map(
          (event) => Community.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  FutureVoid joinCommunity(String userName, String userId) async {
    return right(
      _communities.doc(userName).update({
        'members': FieldValue.arrayUnion(
          [userId],
        ),
      }),
    );
  }

  FutureVoid leaveCommunity(String userName, String userId) async {
    return right(
      _communities.doc(userName).update({
        'members': FieldValue.arrayRemove(
          [userId],
        ),
      }),
    );
  }

  FutureVoid editCommunity(Community community) async {
    try {
      final data = _communities.doc(community.name).update(community.toMap());
      return right(data);
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

  Stream<List<Community>> searchCommunity(String query) {
    return _communities
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map(
      (event) {
        List<Community> communities = [];
        for (var comminity in event.docs) {
          communities.add(
            Community.fromMap(comminity.data() as Map<String, dynamic>),
          );
        }
        return communities;
      },
    );
  }

  FutureVoid addMods(String communityName, List<String> uids) async {
    try {
      final data = _communities.doc(communityName).update({'mods': uids});
      return right(data);
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

  Stream<List<Post>> getCommunityPost(String name) {
    return _post
        .where('communityName', isEqualTo: name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  CollectionReference get _post =>
      _firestore.collection(FirebaseConstants.postsCollection);

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
}
