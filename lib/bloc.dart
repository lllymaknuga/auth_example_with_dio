import 'dart:async';

import 'package:equatable/equatable.dart';
import './repository.dart';
import 'package:bloc/bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class AuthenticationStatusChanged extends AuthenticationEvent {
  AuthenticationStatusChanged(this.authenticationStatus);

  final UserAuthenticationStatus authenticationStatus;

  @override
  List<Object> get props => [authenticationStatus];
}

class LoggedOut extends AuthenticationEvent {}

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class AuthenticationUnknown extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required ProfileRepository profileRepository,
  })  : _profileRepository = profileRepository,
        super(AuthenticationUnknown()) {
    _subscription = _profileRepository.authenticationStatus
        .listen((user) => add(AuthenticationStatusChanged(user)));
    on<AuthenticationStatusChanged>((event, emit) {
      switch (event.authenticationStatus) {
        case UserAuthenticationStatus.signedIn:
          emit(AuthenticationAuthenticated());
          break;
        case UserAuthenticationStatus.signedOut:
          emit(AuthenticationUnauthenticated());
          break;
        case UserAuthenticationStatus.unknown:
        default:
          emit(AuthenticationUnknown());
      }
    });
    on<LoggedOut>((event, emit) async {
      await _profileRepository.logOut();
    });
  }

  final ProfileRepository _profileRepository;

  StreamSubscription<UserAuthenticationStatus>? _subscription;

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
