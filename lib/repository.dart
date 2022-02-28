import 'dart:async';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:untitled1/api_client.dart';

enum UserAuthenticationStatus {
  unknown,
  signedIn,
  signedOut,
}

class ProfileRepository {
  final ApiClient _apiClient = ApiClient();

  Stream<UserAuthenticationStatus> get authenticationStatus {
    return _apiClient.authenticationStatus.map(
      (status) {
        switch (status) {
          case AuthenticationStatus.authenticated:
            return UserAuthenticationStatus.signedIn;
          case AuthenticationStatus.unauthenticated:
            return UserAuthenticationStatus.signedOut;
          case AuthenticationStatus.initial:
          default:
            return UserAuthenticationStatus.unknown;
        }
      },
    );
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    await _apiClient.createUser(email: email, password: password);
  }

  Future<void> logOut() async {
    await _apiClient.logOut();
  }
}
