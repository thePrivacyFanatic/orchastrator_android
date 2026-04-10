import 'package:flutter/material.dart';
import 'package:orchastrator/globals/themes.dart';
import 'package:provider/provider.dart';

/// global theme settings
class AppState extends ChangeNotifier {
  AppState();

  factory AppState.of(BuildContext context, {bool listen = true}) {
    return Provider.of<AppState>(context, listen: listen);
  }

  ThemeData _theme = lightTheme;

  String _themeMode = 'system';

  bool _usePureBlack = false;

  ThemeData get theme {
    return _theme;
  }

  String get themeMode {
    return _themeMode;
  }

  bool get usePureBlack {
    return _usePureBlack;
  }

  void setThemeMode(String mode) {
    _themeMode = mode;
    _updateTheme();
  }

  void setPureBlack(bool value) {
    _usePureBlack = value;
    _updateTheme();
  }

  void _updateTheme() {
    switch (_themeMode) {
      case 'light':
        _theme = lightTheme;
        break;
      case 'dark':
        _theme = _usePureBlack ? pureBlackTheme : darkTheme;
        break;
      case 'system':
        _theme = lightTheme;
        break;
    }
    notifyListeners();
  }

  ThemeData getThemeForBrightness(Brightness brightness) {
    if (_themeMode == 'system') {
      if (brightness == Brightness.dark) {
        return _usePureBlack ? pureBlackTheme : darkTheme;
      }
      return lightTheme;
    }
    return _theme;
  }

  void changeTheme(ThemeData theme) {
    _theme = theme;
    notifyListeners();
  }
}
