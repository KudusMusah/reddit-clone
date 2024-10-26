import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/cubits/app_user/app_user_cubit.dart';
import 'package:reddit_clone/src/core/cubits/theme/theme_cubit.dart';
import 'package:reddit_clone/src/core/enums/theme_mode.dart';
import 'package:reddit_clone/src/core/themes/app_colors.dart';
import 'package:reddit_clone/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = (context.watch<AppUserCubit>().state as UserLoggedIn).user;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 70,
            ),
            const SizedBox(height: 10),
            Text(
              'u/${user.name}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            ListTile(
              title: const Text('My Profile'),
              leading: const Icon(Icons.person),
              onTap: () {
                Routemaster.of(context).push("u/${user.name}");
              },
            ),
            ListTile(
              title: const Text('Log Out'),
              leading: Icon(
                Icons.logout,
                color: AppColors.redColor,
              ),
              onTap: () {
                context.read<AuthBloc>().add(SignOut());
              },
            ),
            BlocBuilder<ThemeCubit, ThemeData>(
              builder: (context, state) {
                return Switch.adaptive(
                  value: context.read<ThemeCubit>().currentTheme ==
                      AppThemeMode.dark,
                  onChanged: (val) {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
