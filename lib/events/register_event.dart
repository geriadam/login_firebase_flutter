import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object> get props => [];
}
class RegisterEventEmailChanged extends RegisterEvent {
  final String email;
  const RegisterEventEmailChanged({this.email});
  @override
  List<Object> get props => [email];
  @override
  String toString() => 'RegisterEventEmailChanged => ${this.email}';
}
class RegisterEventPasswordChanged extends RegisterEvent {
  final String password;
  const RegisterEventPasswordChanged({this.password});
  @override
  List<Object> get props => [password];
  @override
  String toString() => 'RegisterEventPasswordChanged => ${this.password}';
}
class RegisterEvenPressed extends RegisterEvent {
  final String email;
  final String password;
  const RegisterEvenPressed({
    this.email, 
    this.password
  });
  @override
  List<Object> get props => [email, password];
  @override
  String toString() => 'RegisterEvenPressed, email = $email, password = $password';
}