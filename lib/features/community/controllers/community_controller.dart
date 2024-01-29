import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/providers/storage_repository_provider.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/auth/contollers/auth_controller.dart';
import 'package:reddit/features/community/repository/community_repository.dart';
import 'package:reddit/models/community_model.dart';
import 'package:reddit/models/post_model.dart';
import 'package:routemaster/routemaster.dart';

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

final getUserCommunityProvider = StreamProvider(
  (ref) {
    final communityController = ref.watch(communityControllerProvider.notifier);
    return communityController.getUserCommunity();
  },
);

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>(
  (ref) {
    return CommunityController(
      communityRepository: ref.read(communityRepositoryProvider),
      ref: ref,
      storegeRepository: ref.read(storegeRepositoryProvider),
    );
  },
);

final getCommunityPostProvider = StreamProvider.family((ref, String name) {
  return ref.read(communityControllerProvider.notifier).getCommunityPost(name);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final StoregeRepository _storegeRepository;
  final Ref _ref;

  CommunityController({
    required CommunityRepository communityRepository,
    required StoregeRepository storegeRepository,
    required Ref ref,
  })  : _communityRepository = communityRepository,
        _ref = ref,
        _storegeRepository = storegeRepository,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
        id: name,
        name: name,
        avatar: Constants.avatarDefault,
        banner: Constants.bannerDefault,
        members: [uid],
        mods: [uid]);

    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'community added successfully');
        Routemaster.of(context).pop();
      },
    );
  }

  Stream<List<Community>> getUserCommunity() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunity(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity(
      {required Community community,
      required File? profileFile,
      required File? bannerFile,
      required BuildContext context}) async {
    state = true;
    if (profileFile != null) {
      final result = await _storegeRepository.storeFile(
        path: 'communities/profile',
        id: community.name,
        file: profileFile,
      );
      result.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community = community.copyWith(avatar: r),
      );
    }

    if (bannerFile != null) {
      final result = await _storegeRepository.storeFile(
        path: 'comminities/banner',
        id: community.name,
        file: bannerFile,
      );
      result.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community = community.copyWith(banner: r),
      );
    }
    final res = await _communityRepository.editCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.message),
        (r) => Routemaster.of(context).pop());
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  void joinCommunity(Community community, BuildContext context) async {
    final user = _ref.read(userProvider)!;

    Either<Failure, void> res;

    if (community.members.contains(user.uid)) {
      res = await _communityRepository.leaveCommunity(community.name, user.uid);
    } else {
      res = await _communityRepository.joinCommunity(community.name, user.uid);
    }

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        if (community.members.contains(user.uid)) {
          showSnackBar(context, 'leaved community successfully');
        } else {
          showSnackBar(context, 'joined community successfully');
        }
      },
    );
  }

  void addMods(
      String communityName, List<String> uids, BuildContext context) async {
    final res = await _communityRepository.addMods(communityName, uids);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Post>> getCommunityPost(String name) {
    return _communityRepository.getCommunityPost(name);
  }
}
