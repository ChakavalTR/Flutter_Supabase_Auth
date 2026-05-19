import 'package:shared_preferences/shared_preferences.dart';

class LocalServiceStorage {
  static final LocalServiceStorage _instance = LocalServiceStorage._internal();
  late SharedPreferences _prefs;

  LocalServiceStorage._internal();
  static LocalServiceStorage get instance => _instance;

  //! Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //! String storage methods
  //* Set
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  //* Get
  String? getString(String key) {
    return _prefs.getString(key);
  }

  //! Boolean storage methods
  //* Set
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  //* Get
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  //! Integer storage methods
  //* Set
  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  //* Get
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  //! Double storage methods
  //* Set
  Future<void> setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  //* Get
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  //! List<String> storage methods
  //* Set
  Future<void> setStringList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  //* Get
  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  //! Remove a key from storage
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  //! Clear all from storage
  Future<void> clear() async => await _prefs.clear();
}
