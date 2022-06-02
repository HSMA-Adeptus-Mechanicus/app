import 'dart:convert';
import 'package:http/http.dart' as http;

const _apiBasePath = "https://sff-api.azurewebsites.net/api/";
// const _apiBasePath = "http://localhost:7071/api/";

const apiWrapper = _APIWrapper(_apiBasePath);

class ErrorResponseException implements Exception {
  final int code;
  final dynamic data;

  ErrorResponseException(this.code, this.data);

  @override
  String toString() {
    if (data is Map<String, dynamic> && data["error"] is String) {
      return "status: $code, ${data["error"]}";
    }
    return super.toString();
  }
}

/// Provides functions to call the API and abstracts the api url and json parsing away
class _APIWrapper {
  final String _basePath;

  const _APIWrapper(this._basePath);

  Future<dynamic> get(String path) async {
    var response = await http.get(Uri.parse(_basePath + path));
    var result = jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ErrorResponseException(response.statusCode, result);
    }
    return result;
  }

  Future<dynamic> post(String path, dynamic body) async {
    var response =
        await http.post(Uri.parse(_basePath + path), body: jsonEncode(body));
    var result = jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ErrorResponseException(response.statusCode, result);
    }
    return result;
  }

  Future<dynamic> patch(String path, dynamic body) async {
    var response =
        await http.patch(Uri.parse(_basePath + path), body: jsonEncode(body));
    var result = jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ErrorResponseException(response.statusCode, result);
    }
    return result;
  }

  Future<dynamic> delete(String path) async {
    var response = await http.delete(Uri.parse(_basePath + path));
    var result = jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ErrorResponseException(response.statusCode, result);
    }
    return result;
  }
}
