import 'package:login_register_fs_flutter/events/register_event.dart';
import 'package:login_register_fs_flutter/respositories/user_repository.dart';
import 'package:login_register_fs_flutter/states/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_register_fs_flutter/validators/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;
  RegisterBloc({UserRepository userRepository}):
        assert(userRepository!=null),
        _userRepository = userRepository,
        super(RegisterState.initial());
  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(
      Stream<RegisterEvent> registerEvents,
      TransitionFunction<RegisterEvent, RegisterState> transitionFunction,
      ) {
    final debounceStream = registerEvents.where((registerEvent){
      return (registerEvent is RegisterEventEmailChanged || registerEvent is RegisterEventPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    final nonDebounceStream = registerEvents.where((registerEvent){
      return (registerEvent is! RegisterEventEmailChanged && registerEvent is! RegisterEventPasswordChanged);
    });
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFunction);
  }
  @override
  Stream<RegisterState> mapEventToState(RegisterEvent registerEvent) async* {
    final registerState = state;
    if (registerEvent is RegisterEventEmailChanged) {
      yield registerState.cloneAndUpdate(isValidEmail: Validators.isValidEmail(registerEvent.email));
    } else if (registerEvent is RegisterEventPasswordChanged) {
      yield registerState.cloneAndUpdate(isValidPassword: Validators.isValidPassword(registerEvent.password));
    } else if (registerEvent is RegisterEvenPressed) {
      yield RegisterState.loading();
      try {
        await _userRepository.createUserWithEmailAndPassword(registerEvent.email, registerEvent.password);
        yield RegisterState.success();
      } catch (exception) {
        yield RegisterState.failure();
      }
    }
  }
}