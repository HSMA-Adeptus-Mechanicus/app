import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const _apiBasePath = "https://sff-api.azurewebsites.net/api/";
// const _apiBasePath = "http://localhost:7071/api/";

/// Calls the API and abstracts the api url and json parsing away
Future<dynamic> get(String path) async {
  var response = await http.get(Uri.parse(_apiBasePath + path));
  var result = jsonDecode(response.body);
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw ErrorDescription(result["error"]);
  }
  return result;
}

/// Calls the API and abstracts the api url and json parsing away
Future<dynamic> post(String path, dynamic body) async {
  var response =
      await http.post(Uri.parse(_apiBasePath + path), body: jsonEncode(body));
  var result = jsonDecode(response.body);
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw ErrorDescription(result["error"]);
  }
  return result;
}

/// Calls the API and abstracts the api url and json parsing away
Future<dynamic> patch(String path, dynamic body) async {
  var response =
      await http.patch(Uri.parse(_apiBasePath + path), body: jsonEncode(body));
  var result = jsonDecode(response.body);
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw ErrorDescription(result["error"]);
  }
  return result;
}

/// Calls the API and abstracts the api url and json parsing away
Future<dynamic> delete(String path) async {
  var response = await http.delete(Uri.parse(_apiBasePath + path));
  var result = jsonDecode(response.body);
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw ErrorDescription(result["error"]);
  }
  return result;
}
