import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_register_fs_flutter/blocs/authentication_bloc.dart';
import 'package:login_register_fs_flutter/events/authentication_event.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('This is HomePage'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: (){
            BlocProvider.of<AuthenticationBloc>(context)..add(AuthenticationEventLoggedOut());
          })
        ],
      ),
      body: Center(
        child: Text("This is homepage", style: TextStyle(fontSize: 22, color: Colors.green),),
      ),
    );
  }
}