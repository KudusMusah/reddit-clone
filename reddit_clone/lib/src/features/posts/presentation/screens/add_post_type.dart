import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/common/entities/community_entity.dart';
import 'package:reddit_clone/src/core/cubits/app_user/app_user_cubit.dart';
import 'package:reddit_clone/src/core/cubits/community/community_cubit.dart';
import 'package:reddit_clone/src/core/cubits/theme/theme_cubit.dart';
import 'package:reddit_clone/src/core/utils/file_picker.dart';
import 'package:reddit_clone/src/core/utils/snackbar.dart';
import 'package:reddit_clone/src/features/posts/presentation/bloc/posts_bloc/posts_bloc.dart';
import 'package:routemaster/routemaster.dart';

class AddPostType extends StatefulWidget {
  const AddPostType({super.key, required this.type});
  final String type;

  @override
  State<AddPostType> createState() => _AddPostTypeState();
}

class _AddPostTypeState extends State<AddPostType> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  CommunityEntity? selectedCommunity;
  File? bannerFile;

  void _sharePost() {
    final user = (context.read<AppUserCubit>().state as UserLoggedIn).user;
    final userCommmunities =
        (context.read<UserCommunitiesCubit>().state as UserCommunitiesSucess)
            .communities;
    if (widget.type == 'image' &&
        (bannerFile != null) &&
        titleController.text.isNotEmpty) {
      context.read<PostsBloc>().add(
            CreateImagePost(
              image: bannerFile!,
              title: titleController.text.trim(),
              community: selectedCommunity ?? userCommmunities[0],
              user: user,
            ),
          );
    } else if (widget.type == 'text' && titleController.text.isNotEmpty) {
      context.read<PostsBloc>().add(
            CreateTextPost(
              description: descriptionController.text.trim(),
              title: titleController.text.trim(),
              community: selectedCommunity ?? userCommmunities[0],
              user: user,
            ),
          );
    } else if (widget.type == 'link' &&
        titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty) {
      context.read<PostsBloc>().add(
            CreateLinkPost(
              link: linkController.text.trim(),
              title: titleController.text.trim(),
              community: selectedCommunity ?? userCommmunities[0],
              user: user,
            ),
          );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final currentTheme = context.watch<ThemeCubit>().state;
    final userCommmunities =
        (context.watch<UserCommunitiesCubit>().state as UserCommunitiesSucess)
            .communities;

    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        actions: [
          TextButton(
            onPressed: _sharePost,
            child: const Text('Share'),
          ),
        ],
      ),
      body: BlocConsumer<PostsBloc, PostsState>(
        listener: (context, state) {
          if (state is PostsFailure) {
            showSnackBar(context, state.message);
          }
          if (state is PostsSuccess) {
            Routemaster.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is PostsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: 'Enter Title here',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(18),
                  ),
                  maxLength: 30,
                ),
                const SizedBox(height: 10),
                if (isTypeImage)
                  GestureDetector(
                    onTap: selectBannerImage,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(10),
                      dashPattern: const [10, 4],
                      strokeCap: StrokeCap.round,
                      color: currentTheme.textTheme.bodyMedium!.color!,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: bannerFile != null
                            ? Image.file(bannerFile!)
                            : const Center(
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 40,
                                ),
                              ),
                      ),
                    ),
                  ),
                if (isTypeText)
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter Description here',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                    maxLines: 5,
                  ),
                if (isTypeLink)
                  TextField(
                    controller: linkController,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter link here',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                  ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Select Community',
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: DropdownButton(
                    value: selectedCommunity ?? userCommmunities[0],
                    items: userCommmunities
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedCommunity = val;
                      });
                    },
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
