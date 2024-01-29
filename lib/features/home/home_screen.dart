import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/features/auth/contollers/auth_controller.dart';
import 'package:reddit/features/home/delegates/search_community_delegates.dart';
import 'package:reddit/features/home/drawer/community_drawer.dart';
import 'package:reddit/features/home/drawer/profile_drawer.dart';
import 'package:reddit/theme/pallete.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}
  class _HomeScreenState extends ConsumerState<HomeScreen>{

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  int _page =0;

  void pageChange(int page){
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: false,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => displayDrawer(context),
            icon: const Icon(Icons.menu),
          );
        }),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchCommunityDelegates(ref),
              );
            },
            icon: const Icon(Icons.search),
          ),
          Builder(builder: (context) {
            return IconButton(
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                ),
                onPressed: () => displayEndDrawer(context));
          }),
        ],
      ),
      body: Constants.tabWidget[_page],
      drawer: const CommunityDrawer(),
      endDrawer: const ProfileDrawer(),
      bottomNavigationBar: CupertinoTabBar(
        activeColor: currentTheme.iconTheme.color,
        backgroundColor: currentTheme.canvasColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '',
          ),
        ],
        onTap: pageChange,
        currentIndex: _page,
      ),
    );
  }
}
