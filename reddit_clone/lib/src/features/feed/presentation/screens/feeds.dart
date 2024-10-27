import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/features/feed/presentation/widgets/post_card.dart';
import 'package:reddit_clone/src/features/posts/presentation/bloc/community_posts_bloc/user_feed_bloc.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFeedBloc, UserFeedState>(
      builder: (context, state) {
        if (state is UserFeedSuccess) {
          return ListView.builder(
            itemCount: state.posts.length,
            itemBuilder: (context, index) => PostCard(
              post: state.posts[index],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
