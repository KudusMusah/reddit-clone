import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/cubits/theme/theme_cubit.dart';
import 'package:reddit_clone/src/core/themes/app_theme.dart';
import 'package:routemaster/routemaster.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push('/post/$type');
  }

  @override
  Widget build(BuildContext context) {
    double cardHeightWidth = 120;
    double iconSize = 60;
    final currentTheme = context.watch<ThemeCubit>().state;

    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => navigateToType(context, 'image'),
            child: SizedBox(
              height: cardHeightWidth,
              width: cardHeightWidth,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: currentTheme.colorScheme.surface,
                elevation: currentTheme == AppTheme.lightModeAppTheme ? 1 : 16,
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: iconSize,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => navigateToType(context, 'text'),
            child: SizedBox(
              height: cardHeightWidth,
              width: cardHeightWidth,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: currentTheme.colorScheme.surface,
                elevation: currentTheme == AppTheme.lightModeAppTheme ? 1 : 16,
                child: Center(
                  child: Icon(
                    Icons.font_download_outlined,
                    size: iconSize,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => navigateToType(context, 'link'),
            child: SizedBox(
              height: cardHeightWidth,
              width: cardHeightWidth,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: currentTheme.colorScheme.surface,
                elevation: currentTheme == AppTheme.lightModeAppTheme ? 1 : 16,
                child: Center(
                  child: Icon(
                    Icons.link_outlined,
                    size: iconSize,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
