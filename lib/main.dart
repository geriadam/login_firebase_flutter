import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_register_fs_flutter/blocs/authentication_bloc.dart';
import 'package:login_register_fs_flutter/blocs/login_bloc.dart';
import 'package:login_register_fs_flutter/blocs/simple_bloc_observer.dart';
import 'package:login_register_fs_flutter/events/authentication_event.dart';
import 'package:login_register_fs_flutter/pages/home_page.dart';
import 'package:login_register_fs_flutter/pages/login_page.dart';
import 'package:login_register_fs_flutter/pages/splash_page.dart';
import 'package:login_register_fs_flutter/respositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_register_fs_flutter/states/authentication_state.dart';
import 'package:login_register_fs_flutter/states/login_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /*final userRepository = UserRepository();
    userRepository.createUserWithEmailAndPassword("geriadam2@gmail.com", "tes123");*/
    return MaterialApp(
      title: 'Login with Firebase',
      home: BlocProvider(
        create: (context) => AuthenticationBloc(userRepository: _userRepository)..add(AuthenticationEventStarted()),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, authenticationState) {
            if (authenticationState is AuthenticationStateSuccess) {
              return HomePage();
            } else if (authenticationState is AuthenticationStateFailure) {
              return BlocProvider<LoginBloc>(
                create: (context) => LoginBloc(userRepository: _userRepository),
                child: LoginPage(userRepository: _userRepository,),
              );
            }
            return SplashPage();
          },
        ),
      ),
    );
  }
}