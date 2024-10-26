import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/enums/theme_mode.dart';
import 'package:reddit_clone/src/core/themes/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeData> {
  AppThemeMode _currenTheme;
  final SharedPreferences _sharedPreferences;

  ThemeCubit({
    final AppThemeMode currenTheme = AppThemeMode.dark,
    required SharedPreferences sharedPreferences,
  })  : _currenTheme = currenTheme,
        _sharedPreferences = sharedPreferences,
        super(ThemeData.dark());

  AppThemeMode get currentTheme => _currenTheme;

  ThemeData getCurrentTheme() {
    final theme = _sharedPreferences.getString('theme');

    if (theme == "light") {
      emit(AppTheme.lightModeAppTheme);
      _currenTheme = AppThemeMode.light;
    } else {
      emit(AppTheme.darkModeAppTheme);
      _currenTheme = AppThemeMode.dark;
    }
    return state;
  }

  void toggleTheme() {
    if (_currenTheme == AppThemeMode.dark) {
      emit(AppTheme.lightModeAppTheme);
      _sharedPreferences.setString('theme', "light");
    } else {
      emit(AppTheme.darkModeAppTheme);
      _sharedPreferences.setString('theme', "dark");
    }
  }
}
