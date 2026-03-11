import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../data/datasources/local/theme_local_datasource.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final ThemeLocalDataSource themeLocalDataSource;

  ThemeCubit({required this.themeLocalDataSource})
    : super(themeLocalDataSource.getSavedThemeMode());

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await themeLocalDataSource.saveThemeMode(newMode);
    emit(newMode);
  }

  Future<void> setTheme(ThemeMode mode) async {
    await themeLocalDataSource.saveThemeMode(mode);
    emit(mode);
  }
}
