import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_register_fs_flutter/blocs/authentication_bloc.dart';
import 'package:login_register_fs_flutter/blocs/login_bloc.dart';
import 'package:login_register_fs_flutter/events/authentication_event.dart';
import 'package:login_register_fs_flutter/events/login_event.dart';
import 'package:login_register_fs_flutter/pages/buttons/login_button.dart';
import 'package:login_register_fs_flutter/pages/buttons/register_user_button.dart';
import 'package:login_register_fs_flutter/respositories/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:login_register_fs_flutter/states/login_state.dart';

import 'buttons/google_login_button.dart';

class LoginPage extends StatefulWidget {
  final UserRepository _userRepository;
  LoginPage({Key key, UserRepository userRepository}):
      assert(userRepository != null),
      _userRepository = userRepository,
      super(key: key);
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginBloc _loginBloc;
  UserRepository get _userRepository => widget._userRepository;
  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(() {
      _loginBloc.add(LoginEventEmailChanged(email: _emailController.text));
    });
    _passwordController.addListener(() {
      _loginBloc.add(LoginEventPasswordChanged(password: _passwordController.text));
    });
  }
  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  bool isLoginButtonEnabled(LoginState loginState) => loginState.isValidEmailAndPassword && isPopulated && !loginState.isSubmitting;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, loginState) {
          if (loginState.isFailure) {
            print('Login Failed');
          } else if (loginState.isSubmitting) {
            print('Logged In');
          } else if (loginState.isSuccess) {
            BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationEventLoggedIn());
          }
          return Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: 'Enter your email'
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (_) {
                        return loginState.isValidEmail ? null : 'Invalid Email format';
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Enter Password'
                      ),
                      obscureText: true,
                      autocorrect: false,
                      validator: (_) {
                        return loginState.isValidPassword ? null : 'Invalid password format';
                      },
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          LoginButton(
                            onPressed: isLoginButtonEnabled(loginState) ? _onLoginEmailAndPassword : null,
                          ),
                          Padding(padding: EdgeInsets.only(top: 10),),
                          GoogleLoginButton(),
                          Padding(padding: EdgeInsets.only(top: 10),),
                          RegisterUserButton(userRepository: _userRepository,)
                        ],
                      ),
                    )
                  ],
                ),
              ),
          );
        },
      )
    );
  }
  void _onLoginEmailAndPassword() {
    _loginBloc.add(LoginEventWithEmailAndPasswordPressed(
      email: _emailController.text,
      password: _passwordController.text
    ));
  }
}