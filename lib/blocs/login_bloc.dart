import 'package:login_register_fs_flutter/events/login_event.dart';
import 'package:login_register_fs_flutter/respositories/user_repository.dart';
import 'package:login_register_fs_flutter/states/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_register_fs_flutter/validators/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;
  LoginBloc({UserRepository userRepository}):
      assert(userRepository!=null),
      _userRepository = userRepository,
      super(LoginState.initial());
  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
      Stream<LoginEvent> loginEvents,
      TransitionFunction<LoginEvent, LoginState> transitionFunction,
      ) {
    final debounceStream = loginEvents.where((loginEvent){
      return (loginEvent is LoginEventEmailChanged || loginEvent is LoginEventPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    final nonDebounceStream = loginEvents.where((loginEvent){
      return (loginEvent is! LoginEventEmailChanged && loginEvent is! LoginEventPasswordChanged);
    });
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFunction);
  }
  @override
  Stream<LoginState> mapEventToState(LoginEvent loginEvent) async* {
    final loginState = state;
    if (loginEvent is LoginEventEmailChanged) {
      yield loginState.cloneAndUpdate(isValidEmail: Validators.isValidEmail(loginEvent.email));
    } else if (loginEvent is LoginEventPasswordChanged) {
      yield loginState.cloneAndUpdate(isValidPassword: Validators.isValidPassword(loginEvent.password));
    } else if (loginEvent is LoginEventWithGooglePressed) {
      yield LoginState.loading();
      try {
        await _userRepository.signInWithGoogle();
        yield LoginState.success();
      } catch (_) {
        yield LoginState.failure();
      }
    } else if (loginEvent is LoginEventWithEmailAndPasswordPressed) {
      yield LoginState.loading();
      try {
        await _userRepository.signInWithEmailAndPassword(loginEvent.email, loginEvent.password);
        yield LoginState.success();
      } catch (_) {
        yield LoginState.failure();
      }
    }
  }
}