import 'package:sff/data/api/api_wrapper.dart';
import 'package:sff/data/api/user_authentication.dart';

const authAPI = AuthenticatedAPI();

/// Provides functions to call the API and abstracts the api url and json parsing away like APIWrapper. Additionally it adds the authentication token 
class AuthenticatedAPI {
  const AuthenticatedAPI();

  String addTokenToPath(String path) {
    if (!UserAuthentication.getInstance().authenticated) {
      throw Exception(
        "Unable to add authentication token to request because the user is not authenticated",
      );
    }
    if (RegExp(r"\?").firstMatch(path) != null) {
      return "$path&token=${Uri.encodeComponent(UserAuthentication.getInstance().token!)}";
    }
    return "$path?token=${Uri.encodeComponent(UserAuthentication.getInstance().token!)}";
  }

  Future<dynamic> get(String path) async {
    return await apiWrapper.get(addTokenToPath(path));
  }

  Future<dynamic> post(String path, dynamic body) async {
    return await apiWrapper.post(addTokenToPath(path), body);
  }

  Future<dynamic> patch(String path, dynamic body) async {
    return await apiWrapper.patch(addTokenToPath(path), body);
  }

  Future<dynamic> delete(String path) async {
    return await apiWrapper.delete(addTokenToPath(path));
  }
}
