import 'package:flutter/material.dart';
import 'package:reddit/features/auth/screens/login_screen.dart';
import 'package:reddit/features/community/screens/add_mod_screen.dart';
import 'package:reddit/features/community/screens/community_screen.dart';
import 'package:reddit/features/community/screens/create_community_screen.dart';
import 'package:reddit/features/community/screens/edit_community_screen.dart';
import 'package:reddit/features/community/screens/mod_tool_screen.dart';
import 'package:reddit/features/home/home_screen.dart';
import 'package:reddit/features/posts/add_post_type_screen.dart';
import 'package:reddit/features/posts/comment_screen.dart';
import 'package:reddit/features/user_profile/screens/edit_user_profile_screen.dart';
import 'package:reddit/features/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

//loggedOutRout
final loggedOutRout = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: LoginScreen(),
        ),
  },
);

//loggedInRouter
final loggedInRout = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: HomeScreen(),
        ),
    '/community-screen': (_) => const MaterialPage(
          child: CreateComminitySCreen(),
        ),
    '/r/:name': (route) => MaterialPage(
          child: CommunityScreen(
            name: route.pathParameters['name']!,
          ),
        ),
    '/mod-tools/:name': (routeData) => MaterialPage(
          child: ModToolScreen(
            name: routeData.pathParameters['name']!,
          ),
        ),
    '/edit-community/:name': (routeData) => MaterialPage(
          child: EditCommunityScreen(
            name: routeData.pathParameters['name']!,
          ),
        ),
    '/add-mod/:name': (routeData) => MaterialPage(
          child: AddModScreen(
            name: routeData.pathParameters['name']!,
          ),
        ),
    '/u/:uid': (routeData) => MaterialPage(
          child: UserProfileScreen(
            uid: routeData.pathParameters['uid']!,
          ),
        ),
    '/edit-profile/:uid': (routeData) => MaterialPage(
          child: EditUserProfileScreen(
            uid: routeData.pathParameters['uid']!,
          ),
        ),
    '/add-post/:type': (routeData) => MaterialPage(
          child: AddPoastTypeScreen(
            type: routeData.pathParameters['type']!,
          ),
        ),
    '/post/:postId/comments': (route) => MaterialPage(
          child: CommentScreen(
            postId: route.pathParameters['postId']!,
          ),
        ),
  },
);
