import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/cubits/app_user/app_user_cubit.dart';
import 'package:reddit_clone/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reddit_clone/src/core/common/widgets/post_card.dart';
import 'package:reddit_clone/src/features/posts/presentation/bloc/user_posts_bloc/user_posts_bloc.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends StatefulWidget {
  final String uid;
  const UserProfileScreen({super.key, required this.uid});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(GetUserData(uid: widget.uid));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOwnProfile =
        (context.read<AppUserCubit>().state as UserLoggedIn).user.uid ==
            widget.uid;
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is AuthFailure) {
            return Center(
              child: Text(state.message),
            );
          }
          if (state is GetUserDataSuccess) {
            final user = state.user;
            context.read<UserPostsBloc>().add(FetchUserPosts(uid: user.uid));
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 250,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: user.banner,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding:
                              const EdgeInsets.all(20).copyWith(bottom: 70),
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              user.profilePic,
                            ),
                            radius: 45,
                          ),
                        ),
                        if (isOwnProfile)
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.all(20),
                            child: OutlinedButton(
                              onPressed: () {
                                Routemaster.of(context)
                                    .push("/u/${widget.uid}/edit");
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                              ),
                              child: const Text('Edit Profile'),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'u/${user.name}',
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              '5 karma',
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Divider(thickness: 2),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: BlocBuilder<UserPostsBloc, UserPostsState>(
                builder: (context, state) {
                  if (state is UserPostsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is UserPostsFailure) {
                    return Center(
                      child: Text(state.message),
                    );
                  }
                  if (state is UserPostsSuccess) {
                    return ListView.builder(
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) => PostCard(
                        post: state.posts[index],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
