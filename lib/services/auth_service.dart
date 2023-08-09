import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthService with ChangeNotifier, DiagnosticableTreeMixin {
  bool _isAuthenticated = false;
  String? _token;
  User? _currentUser;

  bool get isAuthenticated => _isAuthenticated;

  String? get token => _token;

  User? get currentUser => _currentUser;

  AuthService() {
    _init();
  }

  _init() async {
    await isLoggedIn().then((value) {
      _isAuthenticated = value;
    });
    await _getToken().then((value) {
      _token = value;
    });
    await _getCurrentUser().then((value) {
      _currentUser = value;
    });
    notifyListeners();
  }

  _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('access_token_sl');
    _token = null;
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

  updatePhoto(String photo) async {
    await _getCurrentUser().then((value) {
      _currentUser = value;

      _currentUser?.profilePicture = photo;
      // prefs.setString('user_sl', jsonEncode(user?.toJson()));
      // _currentUser = user;
      // _isAuthenticated = true;
      notifyListeners();
    });
  }

  saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    print('token a guardar: $token');
    prefs.setString('access_token_sl', token);
    _token = token;
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

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('access_token_sl');
    print('token obtenido: $_token');
    return _token;
  }

  _removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user_sl');
  }

  Future<bool> isLoggedIn() async {
    final token = await _getToken();
    return token != null;
  }

  Future<void> logout() async {
    await _removeToken();
    await _removeUser();
    _isAuthenticated = false;
    notifyListeners();
  }
}
