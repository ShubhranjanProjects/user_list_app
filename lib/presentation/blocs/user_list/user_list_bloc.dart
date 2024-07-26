import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:users_app/data/repositories/user_repository.dart';
import 'package:users_app/presentation/blocs/user_list/user_list_event.dart';
import 'package:users_app/presentation/blocs/user_list/user_list_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<FetchUsersEvent>(_onFetchUsers);
    on<FetchUserEvent>(_onFetchUser);
  }

  void _onFetchUsers(FetchUsersEvent event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final users = await userRepository.fetchUsers(event.page);
      emit(UserLoaded(users: users));
    } catch (e) {
      emit(UserError(error: e.toString()));
    }
  }

  void _onFetchUser(FetchUserEvent event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final user = await userRepository.fetchUser(event.userId);
      emit(UserDetailLoaded(user: user));
    } catch (e) {
      emit(UserError(error: e.toString()));
    }
  }
}
