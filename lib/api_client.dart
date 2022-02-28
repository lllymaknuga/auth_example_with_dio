import 'package:dio/dio.dart';
import 'package:fresh_dio/fresh_dio.dart' hide InMemoryTokenStorage;
import 'package:untitled1/token_storage.dart';

class ApiClient {
  final Dio _dio = Dio()
    ..options.connectTimeout = 10000
  ;

  static final _fresh = Fresh.oAuth2(
    tokenStorage: InMemoryTokenStorage(),
    refreshToken: (_, __) async {
      throw RevokeTokenException();
    },
  );

  final _baseUrl = 'https://reqres.in/api';

  Future createUser({required String email, required String password}) async {
    final data = {'email': email, 'password': password};
    print(data);
    Response response = await _dio.post(
      _baseUrl + "/register",
      data: data,
    );
    // ignore: avoid_print
    await _fresh.setToken(
      OAuth2Token(accessToken: response.data['token'], tokenType: 'Bearer'),
    );
  }

  Future<void> logOut() async {
    await _fresh.setToken(null);
  }

  Stream<AuthenticationStatus> get authenticationStatus =>
      _fresh.authenticationStatus;
}
