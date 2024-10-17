import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/dependency_injection.dart';
import 'package:reddit_clone/src/core/cubits/app_user/app_user_cubit.dart';
import 'package:reddit_clone/src/core/routes/routes.dart';
import 'package:reddit_clone/src/core/themes/app_theme.dart';
import 'package:reddit_clone/src/features/auth/presentation/bloc/auth_bloc.dart';
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
          create: (context) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<AppUserCubit>(),
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
          theme: AppTheme.darkModeAppTheme,
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