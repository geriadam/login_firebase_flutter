import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}
class AuthenticationStateInitial extends AuthenticationState {}
class AuthenticationStateSuccess extends AuthenticationState {
  final User user;
  const AuthenticationStateSuccess({this.user});
  @override
  List<Object> get props => [user];
  @override
  String toString() => 'AuthenticationStateSuccess, email : ${user.email}';
}
class AuthenticationStateFailure extends AuthenticationState {
  
}