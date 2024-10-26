import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/cubits/app_user/app_user_cubit.dart';
import 'package:reddit_clone/src/core/utils/snackbar.dart';
import 'package:reddit_clone/src/features/communities/presentation/bloc/create_community/create_community_bloc.dart';
import 'package:routemaster/routemaster.dart';

class CreateCommunityScreen extends StatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  State<CreateCommunityScreen> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  void _createCommunity(user) {
    context.read<CreateCommunityBloc>().add(CreateCommunity(
        name: communityNameController.text.trim(), creatorUid: user.uid));
  }

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AppUserCubit>().state as UserLoggedIn).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a community'),
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
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text('Community name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: communityNameController,
                  decoration: const InputDecoration(
                    hintText: 'r/Community_name',
                    filled: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(18),
                  ),
                  maxLength: 21,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    _createCommunity(user);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Create community',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
