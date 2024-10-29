import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/features/communities/presentation/bloc/create_community/create_community_bloc.dart';
import 'package:routemaster/routemaster.dart';

class CustomSearchDelegates extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    context.read<CreateCommunityBloc>().add(GetQueryCommunities(query: query));
    return BlocBuilder<CreateCommunityBloc, CreateCommunityState>(
      builder: (context, state) {
        if (state is CreateCommunityLoading) {
          return const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is CreateCommunityFailure) {
          return Center(
            child: Text(state.message),
          );
        }
        if (state is GetQueryCommunitySuccess) {
          return ListView.builder(
            itemCount: state.communities.length,
            itemBuilder: (context, idx) {
              final community = state.communities[idx];
              return ListTile(
                onTap: () {
                  Routemaster.of(context).push('/r/${community.name}');
                },
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    community.profileImage,
                  ),
                ),
                title: Text("r/${community.name}"),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
