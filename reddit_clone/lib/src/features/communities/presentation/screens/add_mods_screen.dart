import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/utils/snackbar.dart';
import 'package:reddit_clone/src/features/communities/presentation/bloc/create_community/create_community_bloc.dart';
import 'package:reddit_clone/src/features/communities/presentation/bloc/user_communities/community_bloc.dart';
import 'package:routemaster/routemaster.dart';

class AddModsScreen extends StatefulWidget {
  const AddModsScreen({super.key, required this.name});

  final String name;

  @override
  State<AddModsScreen> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends State<AddModsScreen> {
  final Set<String> uids = {};
  int ctr = 0;

  void _updateMods(
    BuildContext context,
    String communityName,
    List<String> mods,
  ) {
    context.read<CreateCommunityBloc>().add(
          UpdateMods(
            communityName: communityName,
            mods: uids.toList(),
          ),
        );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final name = widget.name.replaceAll("%20", " ");
      context
          .read<CreateCommunityBloc>()
          .add(GetCommunityMembers(communityName: name));
    });
  }

  @override
  Widget build(BuildContext context) {
    final community =
        (context.read<CommunityBloc>().state as GetCommunitySuccess).community;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Moderators"),
        actions: [
          IconButton(
            onPressed: () =>
                _updateMods(context, community.name, uids.toList()),
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: BlocConsumer<CreateCommunityBloc, CreateCommunityState>(
        listener: (context, state) {
          if (state is CreateCommunityFailure) {
            showSnackBar(context, state.message);
          }
          if (state is CreateCommunitySuccess) {
            Routemaster.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is CreateCommunityLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GetCommunityMembersSuccess) {
            ctr++;
            return ListView.builder(
              itemCount: state.members.length,
              itemBuilder: (context, idx) {
                final member = state.members[idx];
                if (community.mods.contains(member.uid) && ctr == 1) {
                  uids.add(member.uid);
                }
                return CheckboxListTile(
                  value: uids.contains(member.uid),
                  onChanged: (val) {
                    if (val == false) {
                      uids.remove(member.uid);
                    } else {
                      uids.add(member.uid);
                    }
                    setState(() {});
                  },
                  title: Text(member.name),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
