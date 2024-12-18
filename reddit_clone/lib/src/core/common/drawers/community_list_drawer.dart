import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/cubits/community/community_cubit.dart';
import 'package:reddit_clone/src/core/themes/app_colors.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends StatelessWidget {
  const CommunityListDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Create a community'),
              leading: const Icon(Icons.add),
              onTap: () {
                Routemaster.of(context).push("create-community");
              },
            ),
            BlocBuilder<UserCommunitiesCubit, UserCommunitiesState>(
              builder: (context, state) {
                if (state is UserCommunitiesLoading) {
                  return const CircularProgressIndicator();
                }
                if (state is UserCommunitiesFailure) {
                  return Text(state.message);
                }
                final communities =
                    (state as UserCommunitiesSucess).communities;

                if (communities.isEmpty) {
                  return ListTile(
                    leading: Icon(
                      Icons.do_not_disturb,
                      color: AppColors.redColor,
                    ),
                    title: const Text("No communities"),
                    subtitle:
                        const Text("Create or search communities to join"),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: communities.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () {
                        Routemaster.of(context)
                            .push('/r/${communities[index].name}');
                      },
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          communities[index].profileImage,
                        ),
                      ),
                      title: Text("r/${communities[index].name}"),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
