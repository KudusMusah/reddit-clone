import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/cubits/app_user/app_user_cubit.dart';
import 'package:reddit_clone/src/core/utils/snackbar.dart';
import 'package:reddit_clone/src/features/posts/presentation/bloc/posts_bloc/posts_bloc.dart';
import 'package:reddit_clone/src/features/posts/presentation/bloc/posts_comments/posts_comments_bloc.dart';
import 'package:reddit_clone/src/features/posts/presentation/widgets/comment_card.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key, required this.id});
  final String id;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final commentController = TextEditingController();
  @override
  void initState() {
    context.read<PostsBloc>().add(GetPostWithId(id: widget.id));
    super.initState();
  }

  void _createComment(BuildContext context) async {
    if (commentController.text.isEmpty) {
      return;
    }
    final user = (context.read<AppUserCubit>().state as UserLoggedIn).user;
    context.read<PostsBloc>().add(CreateComment(
          text: commentController.text.trim(),
          postId: widget.id,
          username: user.name,
          profilePic: user.profilePic,
        ));
    commentController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<PostsBloc, PostsState>(
        listener: (context, state) {
          if (state is PostsFailure) {
            showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is PostsLoading) {
            return const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is GetPostSuccess) {
            final post = state.post;
            context
                .read<PostsCommentsBloc>()
                .add(GetpostComments(postId: post.id));

            return SafeArea(
              child: Column(
                children: [
                  BlocBuilder<PostsCommentsBloc, PostsCommentsState>(
                    builder: (context, state) {
                      if (state is PostsCommentsSuccess) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: state.comments.length,
                            itemBuilder: (BuildContext context, int index) {
                              final comment = state.comments[index];
                              return CommentCard(comment: comment);
                            },
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  TextField(
                    onSubmitted: (val) => _createComment(context),
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: 'What are your thoughts?',
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
