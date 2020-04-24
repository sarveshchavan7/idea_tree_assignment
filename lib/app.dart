import 'package:flutter/material.dart';
import 'package:idea_tree_assignment/bloc/bloc_provider.dart';
import 'package:idea_tree_assignment/bloc/home_bloc.dart';
import 'package:idea_tree_assignment/bloc/login_bloc.dart';
import 'package:idea_tree_assignment/routes_keys.dart';
import 'package:idea_tree_assignment/screens/home.dart';
import 'package:idea_tree_assignment/screens/login.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      routes: {
        RoutesKey.login: (context) {
          return BlocProvider<LoginBloc>(
            blocBuilder: () => LoginBloc(),
            child: Login(),
          );
        },
        RoutesKey.home: (context) {
          return BlocProvider<HomeBloc>(
            blocBuilder: () => HomeBloc(),
            child: Home(
              homebloc: HomeBloc(),
            ),
          );
        },
      },
    );
  }
}
