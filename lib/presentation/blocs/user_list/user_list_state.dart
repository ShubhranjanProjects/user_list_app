

import 'package:users_app/data/models/user.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;

  UserLoaded({required this.users});
}

class UserDetailLoaded extends UserState {
  final User user;

  UserDetailLoaded({required this.user});
}

class UserError extends UserState {
  final String error;

  UserError({required this.error});
}
