import 'package:crud_app/Models/AuthResponse.dart';
import 'package:crud_app/Models/LoginStructure.dart';
import 'package:crud_app/Models/User.dart';
import 'package:dio/dio.dart';
import 'DataService.dart';
import 'package:http/http.dart' as http;


const String BaseUrl = "http://192.168.0.5:1250/Auth";

class UserClient {
  final _dio = Dio(BaseOptions(baseUrl: BaseUrl));
  DataService _dataService = DataService();

  Future<AuthResponse?> Login(LoginStructure user) async {
    try {
      var response = await _dio.post("/login",
          data: {'username': user.username, 'password': user.password});

      var data = response.data['data'];

      var authResponse = new AuthResponse(data['userId'], data['token']);

      if (authResponse.token != null) {
        await _dataService.AddItem("token", authResponse.token);
      }

      return authResponse;
    } catch (error) {
      return null;
    }
  }

  Future<String> GetApiVersion() async {
    var response = await _dio.get("/ApiVersion");
    return response.data;
  }

  Future<List<User>?> GetUsersAsync() async {
    try {
      var token = await _dataService.TryGetItem("token");
      if (await _dataService.TryGetItem("token") != null) {
        var response = await _dio.get("/GetUsers",
            options: Options(headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            }));
        List<User> users = new List.empty(growable: true);
        if (response != null) {
          for (var user in response.data) {
            users.add(User(user["_id"], user["Username"], user["Password"], user["Email"],
                user["AuthLevel"]));
          }
          return users;
        }
      } else {
        return null;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

    Future<void> _deleteUser(String userId) async {
    var url = Uri.parse('https://cmsc2204-mobile-api.onrender.com/Auth/DeleteUserById'); // Replace with your actual API endpoint
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      // Successfully deleted the user
      // Update your UI or state here if needed
    } else {
      // Handle the error
    }
  }
}
