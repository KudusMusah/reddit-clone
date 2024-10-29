import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/constants/constants.dart';
import 'package:reddit_clone/src/core/common/entities/community_entity.dart';
import 'package:reddit_clone/src/core/themes/app_colors.dart';
import 'package:reddit_clone/src/core/themes/app_theme.dart';
import 'package:reddit_clone/src/core/utils/file_picker.dart';
import 'package:reddit_clone/src/core/utils/snackbar.dart';
import 'package:reddit_clone/src/features/communities/presentation/bloc/create_community/create_community_bloc.dart';
import 'package:reddit_clone/src/features/communities/presentation/bloc/user_communities/community_bloc.dart';
import 'package:routemaster/routemaster.dart';

class EditCommunity extends StatefulWidget {
  const EditCommunity({super.key, required this.name});
  final String name;

  @override
  State<EditCommunity> createState() => _EditCommunityState();
}

class _EditCommunityState extends State<EditCommunity> {
  File? _selectedBanner;
  File? _selectedProfile;

  void selectBannerImage() async {
    final image = await pickImage();
    if (image != null) {
      setState(() {
        _selectedBanner = File(image.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final image = await pickImage();
    if (image != null) {
      setState(() {
        _selectedProfile = File(image.files.first.path!);
      });
    }
  }

  void updateCommunity(BuildContext context, CommunityEntity community) {
    if (_selectedBanner == null && _selectedProfile == null) {
      Routemaster.of(context).pop();
      return;
    }
    context.read<CreateCommunityBloc>().add(
          UpdateCommunityEvent(
            community: community,
            profileImage: _selectedProfile,
            bannerImage: _selectedBanner,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final community =
        (context.read<CommunityBloc>().state as GetCommunitySuccess).community;
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        title: const Text('Edit Community'),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => updateCommunity(context, community),
            child: const Text('Save'),
          ),
        ],
      ),
      body: BlocConsumer<CreateCommunityBloc, CreateCommunityState>(
        listener: (context, state) {
          if (state is CreateCommunitySuccess) {
            Routemaster.of(context).pop();
          }
          if (state is CreateCommunityFailure) {
            showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is CreateCommunityLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: selectBannerImage,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          color: AppTheme
                              .darkModeAppTheme.textTheme.bodyMedium!.color!,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: _selectedBanner != null
                                ? Image.file(
                                    _selectedBanner!,
                                    fit: BoxFit.cover,
                                  )
                                : community.banner.isEmpty ||
                                        community.banner ==
                                            Constants.bannerDefault
                                    ? const Center(
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          size: 40,
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: community.banner,
                                        fit: BoxFit.cover,
                                      ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: GestureDetector(
                          onTap: selectProfileImage,
                          child: CircleAvatar(
                            backgroundImage: _selectedProfile != null
                                ? FileImage(_selectedProfile!)
                                : community.profileImage.isEmpty ||
                                        community.profileImage ==
                                            Constants.avatarDefault
                                    ? const NetworkImage(
                                        Constants.avatarDefault)
                                    : CachedNetworkImageProvider(
                                        community.profileImage,
                                      ),
                            radius: 32,
                          ),
                        ),
                      ),
                    ],
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
