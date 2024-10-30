import 'package:flutter/material.dart';
import 'package:reddit_clone/src/core/error/error_pages/user_error_page.dart';
import 'package:reddit_clone/src/features/auth/presentation/screens/landing_page.dart';
import 'package:reddit_clone/src/features/communities/presentation/screens/add_mods_screen.dart';
import 'package:reddit_clone/src/features/communities/presentation/screens/community_screen.dart';
import 'package:reddit_clone/src/features/communities/presentation/screens/create_community.dart';
import 'package:reddit_clone/src/features/communities/presentation/screens/edit_community.dart';
import 'package:reddit_clone/src/features/communities/presentation/screens/mod_tools_screen.dart';
import 'package:reddit_clone/src/features/home/presentation/screens/home_screen.dart';
import 'package:reddit_clone/src/features/posts/presentation/screens/add_post_type.dart';
import 'package:reddit_clone/src/features/posts/presentation/screens/post_detail_screen.dart';
import 'package:reddit_clone/src/features/user_profiles/presentation/screens/user_profile_edit_screen.dart';
import 'package:reddit_clone/src/features/user_profiles/presentation/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoutes = RouteMap(
  routes: {
    "/": (_) => const MaterialPage(child: LandingScreen()),
  },
);

final loggedInRoutes = RouteMap(
  routes: {
    "/": (_) => const MaterialPage(child: HomeScreen()),
    "/create-community": (_) =>
        const MaterialPage(child: CreateCommunityScreen()),
    "/r/:name": (route) => MaterialPage(
          child: CommunityScreen(
            name: route.pathParameters["name"]!,
          ),
        ),
    "/u/:uid": (route) => MaterialPage(
          child: UserProfileScreen(
            uid: route.pathParameters["uid"]!,
          ),
        ),
    "/u/:uid/edit": (route) => MaterialPage(
          child: UserProfileEditScreen(
            uid: route.pathParameters["uid"]!,
          ),
        ),
    "/r/:name/mod-tools": (route) => MaterialPage(
          child: ModToolsScreen(
            name: route.pathParameters['name']!,
          ),
        ),
    "/r/:name/mod-tools/edit": (route) => MaterialPage(
          child: EditCommunity(
            name: route.pathParameters['name']!,
          ),
        ),
    "/r/:name/mod-tools/add-mods": (route) => MaterialPage(
          child: AddModsScreen(
            name: route.pathParameters['name']!,
          ),
        ),
    "/post/:type": (route) => MaterialPage(
          child: AddPostType(
            type: route.pathParameters["type"]!,
          ),
        ),
    "/post/detail/:id": (route) => MaterialPage(
          child: PostDetailScreen(
            id: route.pathParameters["id"]!,
          ),
        ),
  },
);

final userErrorRoutes = RouteMap(
  routes: {
    "/": (_) => const MaterialPage(child: UserErrorPage()),
  },
);
