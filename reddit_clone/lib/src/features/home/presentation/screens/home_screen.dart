import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/common/delegates/custom_search_delegates.dart';
import 'package:reddit_clone/src/core/common/drawers/community_list_drawer.dart';
import 'package:reddit_clone/src/core/common/drawers/profile_drawer.dart';
import 'package:reddit_clone/src/core/cubits/app_user/app_user_cubit.dart';
import 'package:reddit_clone/src/core/cubits/community/community_cubit.dart';
import 'package:reddit_clone/src/core/cubits/theme/theme_cubit.dart';
import 'package:reddit_clone/src/features/communities/presentation/bloc/user_communities/community_bloc.dart';
import 'package:reddit_clone/src/features/feed/presentation/screens/feeds.dart';
import 'package:reddit_clone/src/features/posts/presentation/bloc/community_posts_bloc/user_feed_bloc.dart';
import 'package:reddit_clone/src/features/posts/presentation/screens/add_posts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = (context.read<AppUserCubit>().state as UserLoggedIn).user.uid;
      context.read<CommunityBloc>().add(GetUserCommunities(uid));
    });
    super.initState();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AppUserCubit>().state as UserLoggedIn).user;
    final currentTheme = context.watch<ThemeCubit>().state;
    Widget bodyWidget = const FeedScreen();
    if (_page == 1) {
      bodyWidget = const PostScreen();
    }
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
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegates());
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
          Builder(builder: (context) {
            return IconButton(
              icon: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
                radius: 18,
              ),
              onPressed: () => displayEndDrawer(context),
            );
          }),
        ],
      ),
      body: BlocBuilder<UserCommunitiesCubit, UserCommunitiesState>(
        builder: (context, state) {
          if (state is UserCommunitiesSucess) {
            context
                .read<UserFeedBloc>()
                .add(FetchUserFeed(communities: state.communities));
            return bodyWidget;
          }
          if (state is UserCommunitiesFailure) {
            return Center(child: Text(state.message));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
      bottomNavigationBar: CupertinoTabBar(
        activeColor: currentTheme.iconTheme.color,
        backgroundColor: currentTheme.appBarTheme.backgroundColor,
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Icon(Icons.home),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Icon(Icons.add),
            ),
            label: '',
          ),
        ],
        onTap: onPageChanged,
        currentIndex: _page,
      ),
    );
  }
}
