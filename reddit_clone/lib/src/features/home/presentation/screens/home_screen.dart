import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/common/drawers/community_list_drawer.dart';
import 'package:reddit_clone/src/core/cubits/app_user/app_user_cubit.dart';
import 'package:reddit_clone/src/features/communities/presentation/bloc/community_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AppUserCubit>().state as UserLoggedIn).user;
    context.read<CommunityBloc>().add(GetUserCommunities(user.uid));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: false,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => displayDrawer(context),
          );
        }),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
          IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 18,
            ),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const CommunityListDrawer(),
    );
  }
}
