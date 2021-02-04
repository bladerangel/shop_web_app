import 'package:dio/dio.dart';
import 'package:shop_web_app/providers/auth_provider.dart';

class HttpProvider {
  final Dio _client = Dio();

  static HttpProvider get instance => _instance;

  Dio get client => _client;

  static final HttpProvider _instance = HttpProvider._();

  HttpProvider._() {
    _client.options.baseUrl = 'http://localhost:8080';
    _client.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      final authStoreProvider = AuthStoreProvider.instance;

      if (authStoreProvider.auth?.isAuth == true) {
        options.headers["Authorization"] =
            'Bearer ${authStoreProvider.auth.token}';
      }
      return options;
    }, onResponse: (Response response) {
      return response;
    }, onError: (DioError error) async {
      return error;
    }));
  }
}

class AuthStoreProvider {
  AuthProvider auth;
  static final AuthStoreProvider instance = AuthStoreProvider._();
  AuthStoreProvider._();
}
