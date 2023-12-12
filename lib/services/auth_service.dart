import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthService with ChangeNotifier, DiagnosticableTreeMixin {
  bool _isAuthenticated = false;
  String? _token;
  User? _currentUser;

  bool get isAuthenticated => _isAuthenticated;

  User? get currentUser => _currentUser;

  AuthService() {
    _init();
  }

  _init() async {
    await _getCurrentUser().then((value) {
      _currentUser = value;
      if (_currentUser != null) {
        _isAuthenticated = true;
      }
    });
    notifyListeners();
  }

  saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    print('user a guardar: ${jsonEncode(user.toJson())}');
    prefs.setString('user_sl', jsonEncode(user.toJson()));
    _currentUser = user;
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<User?> _getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user_sl');
    if (user != null) {
      print('user obtenido $user');
      return User.fromJson(jsonDecode(user));
    } else {
      return null;
    }
  }

  _removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user_sl');
  }

  Future<void> logout() async {
    await _removeUser();
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }
}
