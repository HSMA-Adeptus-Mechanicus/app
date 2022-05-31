import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'api_wrapper.dart' as api;

enum LoginState {
  registering,
  loggedIn,
  loggingIn,
  loggedOut,
  loggingOut,
}

/// Handles authentication with the API and storing the access token
class UserAuthentication {
  static UserAuthentication? _authentication;

  static UserAuthentication getInstance() {
    _authentication ??= UserAuthentication();
    return _authentication!;
  }

  UserAuthentication() {
    _broadcastStream = _streamController.stream.asBroadcastStream();
    loadStorage();
  }

  loadStorage() async {
    await _storage.initStorage;
    _token = _storage.read<String>("token");
    await _updateState(
        _token != null ? LoginState.loggedIn : LoginState.loggedOut);
  }

  final GetStorage _storage = GetStorage("login");

  LoginState _state = LoginState.loggingIn;
  String? _username;
  String? _token;
  DateTime? _expirationTime;

  final StreamController<LoginState> _streamController = StreamController();
  late final Stream<LoginState> _broadcastStream;

  bool get authenticated {
    return _token != null;
  }

  LoginState get state {
    return _state;
  }

  String? get username {
    return _username;
  }

  String? get token {
    return _token;
  }

  DateTime? get expirationTime {
    return _expirationTime;
  }

  /// Create a new account with the given username and password
  register(String username, String password) async {
    if (_state != LoginState.loggedOut) {
      throw ErrorDescription("Unable to register while not logged out");
    }
    await _updateState(LoginState.registering);
    try {
      await api.post(
        "auth/register",
        {
          "username": username,
          "password": password,
        },
      );
    } finally {
      await _updateState(LoginState.loggedOut);
    }
    await login(username, password);
  }

  /// Uses the username and password to get an authentication token to authenticate api requests
  login(String username, String password) async {
    await _updateState(LoginState.loggingIn);
    try {
      Map<String, dynamic> result = await api.get(
        "auth/login?username=${Uri.encodeComponent(username)}&password=${Uri.encodeComponent(password)}",
      );
      _token = result["token"];
      _expirationTime = DateTime.fromMillisecondsSinceEpoch(
        result["expirationTime"] * 1000,
        isUtc: true,
      );
    } catch (e) {
      _token = null;
      _expirationTime = null;
      await _updateState(LoginState.loggedOut);
      rethrow;
    }
    await _updateState(LoginState.loggedIn);
  }

  /// Confirm that the current authentication token is valid
  checkLogin() async {
    if (!authenticated) {
      throw ErrorDescription("Currently not logged in");
    }
    try {
      Map<String, dynamic> result = await api.get("/auth/check-token");
      _expirationTime = result["expirationTime"];
    } finally {
      _token = null;
      _expirationTime = null;
      await _updateState(LoginState.loggedOut);
    }
    return authenticated;
  }

  /// Logout and revoke the access token through the API
  logout() async {
    await _updateState(LoginState.loggingOut);
    if (_token == null) {
      await _updateState(LoginState.loggedOut);
      return;
    }
    try {
      await api.delete(
        "auth/revoke-token?token=${Uri.encodeComponent(_token!)}",
      );
    } finally {
      _token = null;
      _expirationTime = null;
      await _updateState(LoginState.loggedOut);
    }
  }

  /// Providing a stream that fires an event when the login status changes with the current login state
  Stream<LoginState> getStateStream() {
    late StreamController<LoginState> controller;
    onListen() {
      controller.add(state);
      controller.addStream(_broadcastStream);
    }

    onCancel() {
      controller.close();
    }

    controller = StreamController(
      onListen: onListen,
      onCancel: onCancel,
    );
    return controller.stream;
  }

  _updateState(LoginState state) async {
    if (state == _state) {
      return;
    }
    _state = state;
    _streamController.add(state);
    await _save();
  }

  _save() async {
    if (!authenticated) {
      await _storage.erase();
    } else {
      await _storage.write("token", _token);
    }
  }
}
