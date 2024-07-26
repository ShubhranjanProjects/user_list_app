import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:users_app/data/repositories/user_repository.dart';
import 'package:users_app/presentation/blocs/user_list/user_list_bloc.dart';
import 'package:users_app/presentation/blocs/user_list/user_list_event.dart';
import 'package:users_app/presentation/blocs/user_list/user_list_state.dart';

class UserDetailScreen extends StatelessWidget {
  final int userId;

  UserDetailScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Color.fromARGB(255, 10, 10, 237),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => UserBloc(context.read<UserRepository>())
          ..add(FetchUserEvent(userId: userId)),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is UserDetailLoaded) {
              final user = state.user;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 80, // Increased the size for prominence
                      backgroundImage: NetworkImage(user.avatar),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'About ${user.firstName}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                      'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                      'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else if (state is UserError) {
              return Center(child: Text('Failed to load user'));
            } else {
              return Center(child: Text('No user details available'));
            }
          },
        ),
      ),
    );
  }
}
