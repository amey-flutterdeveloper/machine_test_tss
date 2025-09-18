import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:machine_test_tss/models/user_model.dart';

Future<List<User>> fetchUsers() async {
  final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"),
    headers: {
      "Accept": "application/json",
    },

  );

print("Message : ${response.statusCode}" );
  if(response.statusCode == 200){

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => User.fromJson(json)).toList();

  }
  else {
    throw Exception('Failed to load users');
  }
}

Future<List<String>> loadFavorites() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('favorites') ?? [];

}

Future<void> saveFavorites(List<User> users) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> favoriteIds = users.where((user) => user.isFavorite).map((user) => user.id.toString()).toList();
  await prefs.setStringList('favorites',favoriteIds);
}