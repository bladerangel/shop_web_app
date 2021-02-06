import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_web_app/providers/auth_provider.dart';

class HttpProvider {
  final Dio _client = Dio();

  static HttpProvider get instance => _instance;

  Dio get client => _client;

  static final HttpProvider _instance = HttpProvider._();

  HttpProvider._() {
    _client.options.baseUrl = 'https://shopbackendspringboot.herokuapp.com';
    _client.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('auth')) {
        final Map<String, dynamic> authData =
            jsonDecode(prefs.getString('auth'));
        final auth = AuthProvider.fromJson(authData);
        if (auth.isAuth) {
          options.headers["Authorization"] = 'Bearer ${auth.token}';
        }
      }

      return options;
    }, onResponse: (Response response) {
      return response;
    }, onError: (DioError error) async {
      return error;
    }));
  }
}
