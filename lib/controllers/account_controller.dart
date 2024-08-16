// controllers/settings_controller.dart
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController {
  Future<void> logout(Function onSuccess) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    onSuccess();
  }
}
