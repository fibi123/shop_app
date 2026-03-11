import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/storage_keys.dart';

abstract class ThemeLocalDataSource {
  Future<void> saveThemeMode(ThemeMode mode);
  ThemeMode getSavedThemeMode();
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final SharedPreferences sharedPreferences;

  ThemeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    await sharedPreferences.setString(StorageKeys.themeMode, mode.name);
  }

  @override
  ThemeMode getSavedThemeMode() {
    final saved = sharedPreferences.getString(StorageKeys.themeMode);
    switch (saved) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.dark;
    }
  }
}
