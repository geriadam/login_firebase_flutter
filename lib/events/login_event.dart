import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}
class LoginEventEmailChanged extends LoginEvent {
  final String email;
  const LoginEventEmailChanged({this.email});
  @override
  List<Object> get props => [email];
  @override
  String toString() => 'Email Changed => ${this.email}';
}
class LoginEventPasswordChanged extends LoginEvent {
  final String password;
  const LoginEventPasswordChanged({this.password});
  @override
  List<Object> get props => [password];
  @override
  String toString() => 'Password Changed => ${this.password}';
}
class LoginEventWithGooglePressed extends LoginEvent{}
class LoginEventWithEmailAndPasswordPressed extends LoginEvent {
  final String email;
  final String password;
  const LoginEventWithEmailAndPasswordPressed({
    @required this.email,
    @required this.password
  });
  @override
  List<Object> get props => [email, password];
  @override
  String toString() => 'LoginEventWithEmailAndPasswordPressed, email = $email, password = $password';
}