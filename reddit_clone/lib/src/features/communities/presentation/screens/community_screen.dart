import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/cubits/app_user/app_user_cubit.dart';
import 'package:reddit_clone/src/core/common/entities/community_entity.dart';
import 'package:reddit_clone/src/features/communities/presentation/bloc/create_community/create_community_bloc.dart';
import 'package:reddit_clone/src/features/communities/presentation/bloc/user_communities/community_bloc.dart';
import 'package:reddit_clone/src/core/common/widgets/post_card.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key, required this.name});
  final String name;

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final name = widget.name.replaceAll("%20", " ");
      context.read<CommunityBloc>().add(GetCommunity(name));
    });
    super.initState();
  }

  void _navigateToModTools(BuildContext context) {
    Routemaster.of(context).push("/r/${widget.name}/mod-tools");
  }

  void _joinOrLeaveCommunity(
      CommunityEntity community, String userId, BuildContext context) {
    if (community.members.contains(userId)) {
      context
          .read<CreateCommunityBloc>()
          .add(LeaveCommunity(communityName: community.name, userId: userId));
    } else {
      context
          .read<CreateCommunityBloc>()
          .add(JoinCommunity(communityName: community.name, userId: userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = (context.watch<AppUserCubit>().state as UserLoggedIn).user;
    return Scaffold(
      body: BlocBuilder<CommunityBloc, CommunityState>(
        builder: (context, state) {
          if (state is CommunityLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is! GetCommunitySuccess) {
            return const Center(
              child: Text("An unexpected error occured"),
            );
          }

          final community = state.community;
          context.read<CreateCommunityBloc>().add(
                FetchCommunityPosts(communityName: community.name),
              );
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: community.banner,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
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
                        Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              community.profileImage,
                            ),
                            radius: 35,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'r/${community.name}',
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            community.mods.contains(user.uid)
                                ? OutlinedButton(
                                    onPressed: () =>
                                        _navigateToModTools(context),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                    ),
                                    child: const Text('Mod Tools'),
                                  )
                                : OutlinedButton(
                                    onPressed: () => _joinOrLeaveCommunity(
                                        community, user.uid, context),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                    ),
                                    child: Text(
                                      community.members.contains(user.uid)
                                          ? "Joined"
                                          : "Join",
                                    ),
                                  )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text("${community.members.length} members"),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: BlocBuilder<CreateCommunityBloc, CreateCommunityState>(
              builder: (context, state) {
                if (state is CreateCommunityLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is CreateCommunityFailure) {
                  return Center(
                    child: Text(state.message),
                  );
                }
                if (state is CommunityPostsSuccess) {
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
        },
      ),
    );
  }
}
