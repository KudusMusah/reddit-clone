import 'package:flutter/material.dart';
import 'package:reddit_clone/src/core/error/error_pages/user_error_page.dart';
import 'package:reddit_clone/src/features/auth/presentation/screens/landing_page.dart';
import 'package:reddit_clone/src/features/communities/presentation/screens/create_community.dart';
import 'package:reddit_clone/src/features/home/presentation/screens/home_screen.dart';
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
  },
);

final userErrorRoutes = RouteMap(
  routes: {
    "/": (_) => const MaterialPage(child: UserErrorPage()),
  },
);
