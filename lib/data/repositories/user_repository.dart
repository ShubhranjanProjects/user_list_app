import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:users_app/data/models/user.dart';

class UserRepository {
  final String baseUrl = 'https://reqres.in/api/users';

  Future<List<User>> fetchUsers(int page) async {
    final response = await http.get(Uri.parse('$baseUrl?page=$page'));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List users = body['data'];
      return users.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> fetchUser(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/$userId'));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return User.fromJson(body['data']);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
