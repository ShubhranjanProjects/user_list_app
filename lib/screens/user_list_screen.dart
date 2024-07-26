import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:users_app/presentation/blocs/user_list/user_list_bloc.dart';
import 'package:users_app/presentation/blocs/user_list/user_list_event.dart';
import 'package:users_app/presentation/blocs/user_list/user_list_state.dart';
import 'package:users_app/screens/user_details_screen.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _loadMoreUsers();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreUsers();
      }
    });
  }

  void _loadMoreUsers() {
    if (!_isFetchingMore) {
      _isFetchingMore = true;
      context.read<UserBloc>().add(FetchUsersEvent(page: _page));
      _page++;
    }
  }

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
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoaded) {
            _isFetchingMore = false;
          }
        },
        builder: (context, state) {
          if (state is UserLoading && _page == 1) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.users.length + 1,
              itemBuilder: (context, index) {
                if (index < state.users.length) {
                  final user = state.users[index];
                  return UserCard(user: user);
                } else if (!_isFetchingMore) {
                  return Center(child: Text('No more users to load'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          } else if (state is UserError) {
            return Center(child: Text('Failed to load users'));
          } else {
            return Center(child: Text('No users available'));
          }
        },
      ),
    );
  }
}

class UserCard extends StatefulWidget {
  final dynamic user; // Assuming the user object has the necessary fields

  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetailScreen(userId: widget.user.id),
            ),
          );
        },
        onHover: (isHovering) {
          setState(() {
            _isHovering = isHovering;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: _isHovering
                ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.6),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(widget.user.avatar),
            ),
            title: Text(
              '${widget.user.firstName} ${widget.user.lastName}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              widget.user.email,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
