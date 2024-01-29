import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/features/community/controllers/community_controller.dart';
import 'package:reddit/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityDrawer extends ConsumerWidget {
  const CommunityDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/community-screen');
  }

  void navigateToCommunity(BuildContext context,Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text('Create community'),
              leading: const Icon(Icons.add),
              onTap: () => navigateToCreateCommunity(context),
            ),
            ref.watch(getUserCommunityProvider).when(
                data: (datas) => ListView.builder(
                      shrinkWrap: true,
                      itemCount: datas.length,
                      itemBuilder: ((context, index) {
                        final community = datas[index];
                        return ListTile(
                          title: Text('r/${community.name}'),
                          leading: CircleAvatar(
                            radius: 14,
                            backgroundImage: NetworkImage(community.avatar),
                          ),
                          onTap: () =>navigateToCommunity(context, community),
                        );
                      }),
                    ),
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader())
          ],
        ),
      ),
    );
  }

  }

