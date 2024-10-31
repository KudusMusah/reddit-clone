import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/common/widgets/post_card.dart';
import 'package:reddit_clone/src/core/themes/app_colors.dart';
import 'package:reddit_clone/src/features/posts/presentation/bloc/user_feed_bloc/user_feed_bloc.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFeedBloc, UserFeedState>(
      builder: (context, state) {
        if (state is UserFeedSuccess) {
          if (state.posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.do_not_disturb,
                        color: AppColors.redColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "Your feed is empty",
                        style: TextStyle(fontSize: 17),
                      )
                    ],
                  ),
                  const Text(
                    "Join or create communities to get active",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          }
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
