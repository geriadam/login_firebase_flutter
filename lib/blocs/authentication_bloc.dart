import 'package:login_register_fs_flutter/events/authentication_event.dart';
import 'package:login_register_fs_flutter/respositories/user_repository.dart';
import 'package:login_register_fs_flutter/states/authentication_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  AuthenticationBloc({UserRepository userRepository}):
      assert(userRepository!=null),
      _userRepository = userRepository,
      super(AuthenticationStateInitial());
  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent authenticationEvent) async* {
    if (authenticationEvent is AuthenticationEventStarted) {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final user = await _userRepository.getUser();
        yield AuthenticationStateSuccess(user: user);
      } else {
        yield AuthenticationStateFailure();
      }
    } else if (authenticationEvent is AuthenticationEventLoggedIn) {
      yield AuthenticationStateSuccess(user: await _userRepository.getUser());
    } else if (authenticationEvent is AuthenticationEventLoggedOut) {
      _userRepository.signOut();
      yield AuthenticationStateFailure();
    }
  }
}