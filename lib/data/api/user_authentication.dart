import 'dart:async';
import 'package:get_storage/get_storage.dart';

import 'api_wrapper.dart';

enum LoginState {
  registering,
  loggedIn,
  loggingIn,
  loggedOut,
  loggingOut,
}

class LoginStateChangeEvent {
  final LoginState previous;
  final LoginState state;

  LoginStateChangeEvent(this.previous, this.state);
}

/// Handles authentication with the API and storing the access token
class UserAuthentication {
  static UserAuthentication? _authentication;

  static UserAuthentication getInstance() {
    _authentication ??= UserAuthentication();
    return _authentication!;
  }

  UserAuthentication() {
    _stateBroadcastStream = _streamController.stream.asBroadcastStream();
    _usernameBroadcastStream = _stateBroadcastStream.map((event) => _username,);
    loadStorage();
  }

  loadStorage() async {
    await _storage.initStorage;
    try {
      var data = _storage.read<Map<String, dynamic>>("token");
      if (data!["token"] is String) {
        _token = data["token"];
        if (data["expirationTime"] is int) {
          _expirationTime =
              DateTime.fromMillisecondsSinceEpoch(data["expirationTime"]);
        }
        if (data["username"] is String) {
          _username = data["username"];
        }
        if (data["userId"] is String) {
          _userId = data["userId"];
        }
      }
      await checkLogin();
    } catch (e) {
      await _updateState(LoginState.loggedOut);
    }
  }

  final GetStorage _storage = GetStorage("login");

  LoginState _state = LoginState.loggingIn;
  String? _username;
  String? _token;
  DateTime? _expirationTime;
  String? _userId;

  final StreamController<LoginState> _streamController = StreamController();
  late final Stream<LoginState> _stateBroadcastStream;
  late final Stream<String?> _usernameBroadcastStream;

  bool get authenticated {
    return _token != null;
  }

  LoginState get state {
    return _state;
  }

  String? get username {
    return _username;
  }

  String? get userId {
    return _userId;
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
      throw Exception("Unable to register while not logged out");
    }
    await _updateState(LoginState.registering);
    try {
      await apiWrapper.post(
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
      Map<String, dynamic> result = await apiWrapper.get(
        "auth/login?username=${Uri.encodeComponent(username)}&password=${Uri.encodeComponent(password)}",
      );
      _username = username;
      _userId = result["userId"];
      _token = result["token"];
      _expirationTime = DateTime.fromMillisecondsSinceEpoch(
        result["expirationTime"] * 1000,
        isUtc: true,
      );
    } catch (e) {
      await _logoutClientSide();
      rethrow;
    }
    await _updateState(LoginState.loggedIn);
  }

  refreshToken() async {
    if (!authenticated) {
      throw Exception("There is no token to be refreshed");
    }
    _updateState(LoginState.loggingIn);
    try {
      String oldToken = _token!;

      Map<String, dynamic> result = await apiWrapper.get(
        "/auth/refresh-token?token=${Uri.encodeComponent(_token!)}",
      );
      _username = username;
      _userId = result["userId"];
      _token = result["token"];
      _expirationTime = DateTime.fromMillisecondsSinceEpoch(
        result["expirationTime"] * 1000,
        isUtc: true,
      );
      await _updateState(LoginState.loggedIn);

      apiWrapper
          .delete("auth/revoke-token?token=${Uri.encodeComponent(oldToken)}")
          .ignore();
    } catch (e) {
      await checkLogin();
    }
    return authenticated;
  }

  // TODO: Add automatic token refreshing (and token refreshing in general)
  /// Confirm that the current authentication token is valid
  checkLogin() async {
    if (!authenticated) {
      _updateState(LoginState.loggedOut);
      return;
    }
    try {
      Map<String, dynamic> result = await apiWrapper.get(
        "/auth/check-token?token=${Uri.encodeComponent(_token!)}",
      );
      _username = result["username"];
      _userId = result["userId"];
      _expirationTime = DateTime.fromMillisecondsSinceEpoch(
        result["expirationTime"] * 1000,
        isUtc: true,
      );
      await _updateState(LoginState.loggedIn);
    } on ErrorResponseException {
      await _logoutClientSide();
    } catch (e) {
      // The server did not respond with a proper error
      // (this means there was an internal server error or there is not even an internet connection)
      await _updateState(LoginState.loggedIn);
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
      await apiWrapper.delete(
        "auth/revoke-token?token=${Uri.encodeComponent(_token!)}",
      );
    } catch (e) {
      return;
    } finally {
      await _logoutClientSide();
    }
  }

  _logoutClientSide() async {
    _token = null;
    _username = null;
    _userId = null;
    _expirationTime = null;
    await _updateState(LoginState.loggedOut);
  }

  editPassword(String password, String newPassword) async {
    if (_username == null) {
      throw Exception("Unable to edit password when not logged in");
    }
    await _updateState(LoginState.loggingOut);
    try {
      await apiWrapper.patch(
        "auth/edit-password?username=${Uri.encodeComponent(_username!)}&password=${Uri.encodeComponent(password)}",
        {"password": newPassword},
      );
      await _logoutClientSide();
    } finally {
      await checkLogin();
    }
  }

  editUsername(String password, String newUsername) async {
    // TODO: add stream that allows detecting the change of the username to automatically update it in the UI
    if (_username == null) {
      throw Exception("Unable to edit username when not logged in");
    }
    await apiWrapper.patch(
      "auth/edit-username?username=${Uri.encodeComponent(_username!)}&password=${Uri.encodeComponent(password)}",
      {"username": newUsername},
    );
    _username = newUsername;
    _updateState(LoginState.loggedIn);
  }

  deleteAccount(String password) async {
    await _updateState(LoginState.loggingOut);
    if (_username == null) {
      throw Exception("Unable to edit username when not logged in");
    }
    try {
      await apiWrapper.delete(
        "auth/delete-account?username=${Uri.encodeComponent(_username!)}&password=${Uri.encodeComponent(password)}",
      );
      await _logoutClientSide();
    } finally {
      await checkLogin();
    }
  }

  /// Providing a stream that fires an event when the username changes with the current username
  Stream<String?> getUsernameStream() {
    late StreamController<String?> controller;
    onListen() {
      controller.add(username);
      controller.addStream(_usernameBroadcastStream);
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

  /// Providing a stream that fires an event when the login status changes with the current login state
  Stream<LoginState> getStateStream() {
    late StreamController<LoginState> controller;
    onListen() {
      controller.add(state);
      controller.addStream(_stateBroadcastStream);
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

  /// Providing a stream that fires an event when the login status changes with the previous and current login state
  Stream<LoginStateChangeEvent> getChangeStateStream() {
    late StreamController<LoginStateChangeEvent> controller;
    onListen() {
      LoginState previous = state;
      controller.addStream(_stateBroadcastStream.map((state) {
        var change = LoginStateChangeEvent(previous, state);
        previous = state;
        return change;
      }));
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
    _state = state;
    _streamController.add(state);
    await _save();
  }

  _save() async {
    await _storage.initStorage;
    if (!authenticated) {
      await _storage.erase();
    } else {
      await _storage.write("token", {
        "token": _token,
        "expirationTime": expirationTime?.millisecondsSinceEpoch,
        "username": _username,
        "userId": _userId,
      });
    }
  }
}
