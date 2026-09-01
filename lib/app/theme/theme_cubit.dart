import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences _prefs;
  static const String _themeKey = 'resto_theme_mode';

  ThemeCubit(this._prefs) : super(_loadInitialTheme(_prefs));

  static ThemeMode _loadInitialTheme(SharedPreferences prefs) {
    final savedMode = prefs.getString(_themeKey);
    if (savedMode == 'dark') return ThemeMode.dark;
    if (savedMode == 'light') return ThemeMode.light;
    return ThemeMode.system;
  }

  void toggleTheme() {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    setTheme(newMode);
  }

  void setTheme(ThemeMode mode) {
    emit(mode);
    if (mode == ThemeMode.dark) {
      _prefs.setString(_themeKey, 'dark');
    } else if (mode == ThemeMode.light) {
      _prefs.setString(_themeKey, 'light');
    } else {
      _prefs.remove(_themeKey);
    }
  }

  bool get isDarkMode => state == ThemeMode.dark;
}
