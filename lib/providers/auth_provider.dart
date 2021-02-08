import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './http_provider.dart';

part 'auth_provider.g.dart';

@JsonSerializable()
class Role {
  final int id;
  final RoleName name;

  Role({
    this.id,
    this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
  Map<String, dynamic> toJson() => _$RoleToJson(this);
}

enum RoleName {
  ROLE_USER,
  ROLE_ADMIN,
}

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final List<Role> roles;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.roles,
  });

  User copy({
    int id,
    String name,
    String email,
    String password,
    List<Role> roles,
    String token,
    DateTime expiryDate,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        roles: roles ?? this.roles,
      );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class AuthProvider with ChangeNotifier {
  User _user;
  String _token;
  DateTime _expiryDate;
  Timer _authTimer;

  AuthProvider({
    User user,
    String token,
    DateTime expiryDate,
  }) {
    _user = user;
    _token = token;
    _expiryDate = expiryDate;
  }

  User get user => _user;

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  DateTime get expiryDate => _expiryDate;

  bool get isAuth => _token != null;

  bool get isAdmin => _user != null
      ? _user.roles.map((role) => role.name).contains(RoleName.ROLE_ADMIN)
      : false;

  factory AuthProvider.fromJson(Map<String, dynamic> json) =>
      _$AuthProviderFromJson(json);
  Map<String, dynamic> toJson() => _$AuthProviderToJson(this);

  final _httpRequest = HttpProvider.instance.client;

  final _url = '/user';

  Future<void> signup(User auth) async {
    try {
      await _httpRequest.post('$_url/signup', data: auth.toJson());
      await login(auth);
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(User auth) async {
    try {
      final response =
          await _httpRequest.post('$_url/signin', data: auth.toJson());
      final authResponse = AuthProvider.fromJson(response.data);
      _user = authResponse.user;
      _token = authResponse.token;
      _expiryDate = authResponse.expiryDate;

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('auth', jsonEncode(toJson()));

      _autoLogout();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('auth')) {
      return false;
    }
    final Map<String, dynamic> authData = jsonDecode(prefs.getString('auth'));
    final auth = AuthProvider.fromJson(authData);
    if (auth.expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _user = auth.user;
    _token = auth.token;
    _expiryDate = auth.expiryDate;

    _autoLogout();
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    try {
      _user = null;
      _token = null;
      _expiryDate = null;

      if (_authTimer != null) {
        _authTimer.cancel();
        _authTimer = null;
      }
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
