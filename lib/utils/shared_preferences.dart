part of '../diomond.dart';

class SharedPreferencesHelper {
  static const String kAccesToken = "access_token";

  static Future<String> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(kAccesToken) ?? '';
  }

  static removeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(kAccesToken);
  }
}
