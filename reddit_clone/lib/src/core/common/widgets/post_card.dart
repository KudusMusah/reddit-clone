import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/constants/constants.dart';
import 'package:reddit_clone/src/core/cubits/app_user/app_user_cubit.dart';
import 'package:reddit_clone/src/core/cubits/theme/theme_cubit.dart';
import 'package:reddit_clone/src/core/enums/karma.dart';
import 'package:reddit_clone/src/core/themes/app_colors.dart';
import 'package:reddit_clone/src/core/utils/snackbar.dart';
import 'package:reddit_clone/src/core/common/entities/post_entity.dart';
import 'package:reddit_clone/src/features/posts/presentation/bloc/posts_bloc/posts_bloc.dart';
import 'package:reddit_clone/src/features/user_profiles/presentation/bloc/profile_bloc.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});
  final PostEntity post;

  void _awardPost(
    BuildContext context,
    String award,
    PostEntity post,
    String userId,
  ) {
    context.read<PostsBloc>().add(AwardPost(
        award: award, postId: post.id, userId: userId, posterId: post.uid));
    context
        .read<ProfileBloc>()
        .add(UpdateKarma(karma: UserKarma.awardPost, uid: userId));
  }

  void _showDialog(BuildContext context, user) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: BlocConsumer<PostsBloc, PostsState>(
          listener: (context, state) {
            if (state is AwardPostSuccess) {
              Routemaster.of(context).pop();
              showSnackBar(context, "Post awarded!");
            }

            if (state is PostsFailure) {
              showSnackBar(context, state.message);
              Routemaster.of(context).pop();
            }
          },
          builder: (context, state) {
            if (state is PostsLoading) {
              return ListView(shrinkWrap: true, children: const [
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(55),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ]);
            }
            return Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: user.awards.length,
                itemBuilder: (context, index) {
                  final award = user.awards[index];
                  return GestureDetector(
                    onTap: () => _awardPost(context, award, post, user.uid),
                    child: Image.asset(
                      Constants.awards[award]!,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _openDialogBox(BuildContext context, String postId, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        actions: [
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text("Are you sure you want to delete"),
            ),
          ),
          BlocConsumer<PostsBloc, PostsState>(
            listener: (context, state) {
              if (state is PostsFailure) {
                Routemaster.of(context).pop();
                showSnackBar(context, state.message);
              }
              if (state is PostsSuccess) {
                Routemaster.of(context).pop();
                showSnackBar(context, "Post has been deleted!");
              }
            },
            builder: (context, state) {
              if (state is PostsLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }
              return TextButton(
                onPressed: () {
                  context.read<PostsBloc>().add(DeletePost(postId: postId));
                  context.read<ProfileBloc>().add(
                      UpdateKarma(karma: UserKarma.deletePost, uid: userId));
                },
                child: const Center(child: Text("Yes")),
              );
            },
          ),
          TextButton(
            onPressed: () => Routemaster.of(context).pop(),
            child: const Center(child: Text("Cancel")),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.watch<ThemeCubit>().state;
    final user = (context.read<AppUserCubit>().state as UserLoggedIn).user;
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';

    return Column(
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              color: currentTheme.drawerTheme.backgroundColor,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 16,
                        ).copyWith(right: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => Routemaster.of(context)
                                          .push('/r/${post.communityName}'),
                                      child: CircleAvatar(
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          post.communityProfilePic,
                                        ),
                                        radius: 16,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'r/${post.communityName}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => Routemaster.of(context)
                                                .push('/u/${post.uid}'),
                                            child: Text(
                                              'u/${post.username}',
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (post.uid == user.uid)
                                  IconButton(
                                    onPressed: () => _openDialogBox(
                                        context, post.id, user.uid),
                                    icon: Icon(
                                      Icons.delete,
                                      color: AppColors.redColor,
                                    ),
                                  ),
                              ],
                            ),
                            if (post.awards.isNotEmpty) ...[
                              const SizedBox(height: 5),
                              SizedBox(
                                height: 25,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: post.awards.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final award = post.awards[index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Image.asset(
                                        Constants.awards[award]!,
                                        height: 23,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                post.title,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isTypeImage)
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                width: double.infinity,
                                child: CachedNetworkImage(
                                  imageUrl: post.imageUrl!,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            if (isTypeLink)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: AnyLinkPreview(
                                  displayDirection:
                                      UIDirection.uiDirectionHorizontal,
                                  link: post.link!,
                                ),
                              ),
                            if (isTypeText)
                              Container(
                                alignment: Alignment.bottomLeft,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Text(
                                  post.description!,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => context
                                          .read<PostsBloc>()
                                          .add(UpvotePost(
                                              userId: user.uid, post: post)),
                                      icon: Icon(
                                        Icons.arrow_upward,
                                        size: 30,
                                        color: post.upvotes.contains(user.uid)
                                            ? AppColors.redColor
                                            : null,
                                      ),
                                    ),
                                    Text(
                                      '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                    IconButton(
                                      onPressed: () => context
                                          .read<PostsBloc>()
                                          .add(DownvotePost(
                                              userId: user.uid, post: post)),
                                      icon: Icon(
                                        Icons.arrow_downward,
                                        size: 30,
                                        color: post.downvotes.contains(user.uid)
                                            ? AppColors.blueColor
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => Routemaster.of(context)
                                      .push('/post/comments/${post.id}'),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.comment,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _showDialog(context, user),
                                  icon: const Icon(
                                    Icons.card_giftcard_outlined,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
