import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/cubits/app_user/app_user_cubit.dart';
import 'package:reddit_clone/src/core/cubits/community/community_cubit.dart';
import 'package:reddit_clone/src/core/cubits/theme/theme_cubit.dart';
import 'package:reddit_clone/src/core/dependency_injection/dependency_injection_imports.dart';
import 'package:reddit_clone/src/core/routes/routes.dart';
import 'package:reddit_clone/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reddit_clone/src/features/communities/presentation/bloc/create_community/create_community_bloc.dart';
import 'package:reddit_clone/src/features/communities/presentation/bloc/user_communities/community_bloc.dart';
import 'package:reddit_clone/src/features/posts/presentation/bloc/user_feed_bloc/user_feed_bloc.dart';
import 'package:reddit_clone/src/features/posts/presentation/bloc/posts_bloc/posts_bloc.dart';
import 'package:reddit_clone/src/features/posts/presentation/bloc/user_posts_bloc/user_posts_bloc.dart';
import 'package:reddit_clone/src/features/user_profiles/presentation/bloc/profile_bloc.dart';
import 'package:routemaster/routemaster.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocator<ThemeCubit>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<AppUserCubit>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<CommunityBloc>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<UserCommunitiesCubit>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<CreateCommunityBloc>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<ProfileBloc>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<PostsBloc>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<UserFeedBloc>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<UserPostsBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUserCubit, AppUserState>(
      builder: (context, state) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Reddit Clone',
          theme: context.watch<ThemeCubit>().getCurrentTheme(),
          routerDelegate: RoutemasterDelegate(
            routesBuilder: (context) {
              if (state is UserAuthenticated) {
                context
                    .read<AuthBloc>()
                    .add(GetSignedInUserData(uid: state.uid));
              }
              if (state is UserLoggedIn) {
                return loggedInRoutes;
              }
              return loggedOutRoutes;
            },
          ),
          routeInformationParser: const RoutemasterParser(),
        );
      },
    );
  }
}
