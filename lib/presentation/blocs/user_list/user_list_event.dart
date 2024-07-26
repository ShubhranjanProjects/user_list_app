abstract class UserEvent {}

class FetchUsersEvent extends UserEvent {
  final int page;

  FetchUsersEvent({required this.page});
}

class FetchUserEvent extends UserEvent {
  final int userId;

  FetchUserEvent({required this.userId});
}
