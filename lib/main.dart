import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:users_app/data/repositories/user_repository.dart';
import 'package:users_app/presentation/blocs/user_list/user_list_bloc.dart';
import 'package:users_app/screens/user_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserRepository>(create: (_) => UserRepository()),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(context.read<UserRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'User List App',
        theme: ThemeData(
          fontFamily: 'SF-Pro',
          primarySwatch: Colors.blue,
        ),
        home: UserListScreen(),
      ),
    );
  }
}
