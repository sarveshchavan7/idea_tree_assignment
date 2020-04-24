import 'package:flutter/material.dart';
import 'package:idea_tree_assignment/bloc/bloc_provider.dart';
import 'package:idea_tree_assignment/bloc/login_bloc.dart';
import 'package:idea_tree_assignment/routes_keys.dart';
import 'package:idea_tree_assignment/widgets/login_with.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginBloc _loginBloc;

  @override
  Widget build(BuildContext context) {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _welcome(),
          SizedBox(
            height: 70,
          ),
          _loginWithFingerPrint(),
          SizedBox(
            height: 30,
          ),
          _loginWithFaceBook(),
        ],
      ),
    ));
  }

  Widget _welcome() {
    return Padding(
      padding: EdgeInsets.only(left: 40.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          'WELCOME BACK',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  Widget _loginWithFaceBook() {
    return LoginWithBtn(
      imgUrl: 'assets/ic_fb.png',
      onPressed: () async {
        if (await _loginBloc.faceBookLogin()) {
          _navigateToHomePage();
        }
      },
      btnText: 'Continue with FaceBook',
    );
  }

  Widget _loginWithFingerPrint() {
    return LoginWithBtn(
      imgUrl: 'assets/ic_finger_print.png',
      onPressed: () async {
        if (await _loginBloc.authenticate()) {
          _navigateToHomePage();
        }
      },
      btnText: 'Continue with FingerPrint',
    );
  }

  void _navigateToHomePage() {
    Navigator.pushReplacementNamed(context, RoutesKey.home);
  }
}
