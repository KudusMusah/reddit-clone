import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/cubits/community/community_cubit.dart';
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
            const SizedBox(height: 20),
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: communities
                      .map(
                        (community) => Padding(
                          padding: const EdgeInsets.fromLTRB(25, 6, 0, 6),
                          child: Text(community.name),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
