import 'dart:convert';
import 'package:rest_api/constants/constants.dart';
import "package:http/http.dart" as http;
import 'package:rest_api/models/usermodel.dart';

class ApiService {
  Future<List<UserModel>?> getEmployees() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.userEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<UserModel> model = userModelFromJson(response.body);
        return model;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<UserModel> createUser(String name) async {
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.userEndpoint);
    final headers = {"Content-Type": "application/json; charset=UTF-8"};
    Map<String, String> body = {"name": name};
    String jsonBody = json.encode(body);

    final response = await http.post(url, headers: headers, body: jsonBody);
    if (response.statusCode == 201) {
      print("ResponseBody ${response.statusCode}");
      print("ResponseBody ${response.body}");
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create user");
    }
  }
}
