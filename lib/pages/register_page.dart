import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_register_fs_flutter/blocs/authentication_bloc.dart';
import 'package:login_register_fs_flutter/blocs/register_bloc.dart';
import 'package:login_register_fs_flutter/events/authentication_event.dart';
import 'package:login_register_fs_flutter/events/register_event.dart';
import 'package:login_register_fs_flutter/pages/buttons/register_button.dart';
import 'package:login_register_fs_flutter/respositories/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:login_register_fs_flutter/states/register_state.dart';

class RegisterPage extends StatefulWidget {
  final UserRepository _userRepository;
  RegisterPage({Key key, UserRepository userRepository}):
        assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  RegisterBloc _registerBloc;
  UserRepository get _userRepository => widget._userRepository;
  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(() {
      _registerBloc.add(RegisterEventEmailChanged(email: _emailController.text));
    });
    _passwordController.addListener(() {
      _registerBloc.add(RegisterEventPasswordChanged(password: _passwordController.text));
    });
  }
  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  bool isRegisterButtonEnabled(RegisterState registerState) => registerState.isValidEmailAndPassword && isPopulated && !registerState.isSubmitting;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, registerState) {
            if (registerState.isFailure) {
              print('Register Failed');
            } else if (registerState.isSubmitting) {
              print('Logged In');
            } else if (registerState.isSuccess) {
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
                        return registerState.isValidEmail ? null : 'Invalid Email format';
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
                        return registerState.isValidPassword ? null : 'Invalid password format';
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: RegisterButton(
                        onPressed: () {
                          if (isRegisterButtonEnabled(registerState)) {
                            _registerBloc.add(
                                RegisterEvenPressed(
                                  email: _emailController.text,
                                  password: _passwordController.text
                                )
                            );
                          }
                        }
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
}