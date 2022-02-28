import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:untitled1/repository.dart';

enum Status { init, loading, success, failure }

class LoginState {
  const LoginState(
      {this.status = Status.init, this.email = "", this.password = ""});

  final Status status;
  final String email;
  final String password;

  LoginState copyWith({
    Status? status,
    String? email,
    String? password,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

class LoginCubit extends Cubit<LoginState> {
  ProfileRepository profileRepository = ProfileRepository();

  LoginCubit() : super(const LoginState(status: Status.init));

  Future<void> changeInit() async {
    emit(state.copyWith(status: Status.init));
  }

  Future<void> emailChanged(String value) async {
    emit(state.copyWith(email: value));
  }

  Future<void> passwordChanged(String value) async {
    emit(state.copyWith(password: value));
  }

  Future<void> submitted() async {
    emit(state.copyWith(status: Status.loading));
    try {
      await profileRepository.logIn(password: state.password, email: state.email);
      emit(state.copyWith(status: Status.success));
    } on DioError catch(e){
      print(e);
      emit(state.copyWith(status: Status.failure));
    }
  }
}
