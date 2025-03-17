import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://66f0dae1f2a8bce81be6cd25.mockapi.io/student/students";

  Future<List<dynamic>> getAll() async {
    var res = await http.get(Uri.parse(baseUrl));
    List<dynamic> data = jsonDecode(res.body);
    print(data);
    return data;
  }
  Future<Map<String, dynamic>> addUser(Map<String, dynamic> userData) async {
    var res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userData),
    );
    Map<String, dynamic> data = jsonDecode(res.body);
    print(data);
    return data;
  }

  Future<Map<String, dynamic>> updateUser(String id, Map<String, dynamic> userData) async {

    print("::: from update user :::");

    print(userData);



    var res = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userData),
    );
    Map<String, dynamic> data = jsonDecode(res.body);
    print(data);
    return data;
  }

  Future<Map<String, dynamic>> deleteUser(String id) async {
    var res = await http.delete(Uri.parse("$baseUrl/$id"));
    Map<String, dynamic> data = jsonDecode(res.body);
    print(data);
    return data;
  }
  Future<void> toggleFavorite(String id, bool currentStatus) async {
    await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"isFavorite": !currentStatus}),
    );
  }
}
