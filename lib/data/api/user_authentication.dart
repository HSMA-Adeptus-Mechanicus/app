import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:get_storage/get_storage.dart';
import 'package:sff/data/api/authenticated_api.dart';

import 'api_wrapper.dart';

enum LoginState {
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
    loadStorage();
  }

  loadStorage() async {
    await _storage.initStorage;
    try {
      var data = _storage.read<Map<String, dynamic>>("token");
      if (data!["token"] is String) {
        _token = data["token"];
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
  String? _token;
  String? _userId;

  final StreamController<LoginState> _streamController = StreamController();
  late final Stream<LoginState> _stateBroadcastStream;

  bool get authenticated {
    return state == LoginState.loggedIn && _token != null;
  }

  LoginState get state {
    return _state;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    return _token;
  }

  String startAuthentication() {
    if (authenticated) {
      throw Exception("Already authenticated");
    }
    _updateState(LoginState.loggingIn);

    Random random = Random.secure();
    String token =
        base64Encode(List<int>.generate(32, (index) => random.nextInt(1 << 8)));
    _token = token;
    return token;
  }

  Future<void> completeAuthentication() async {
    if (state != LoginState.loggingIn || _token == null) {
      throw Exception("To complete, authentication has to be in progress");
    }
    Map<String, dynamic> result = await apiWrapper.get(
      "auth/check-token?token=${Uri.encodeComponent(_token!)}",
    );
    _userId = result["userId"];
    await _updateState(LoginState.loggedIn);
  }

  Future<void> cancelAuthentication() async {
    if (state != LoginState.loggingIn) {
      throw Exception("Can not cancel authentication that is not in progress");
    }
    await _logoutClientSide();
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
      _userId = result["userId"];
      _token = result["token"];
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
    if (_token == null) {
      _updateState(LoginState.loggedOut);
      return;
    }
    try {
      Map<String, dynamic> result = await apiWrapper.get(
        "/auth/check-token?token=${Uri.encodeComponent(_token!)}",
      );
      _userId = result["userId"];
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
    _userId = null;
    await _updateState(LoginState.loggedOut);
  }

  deleteAccount(String password) async {
    await _updateState(LoginState.loggingOut);
    try {
      await authAPI.delete(
        "auth/delete-account",
      );
      await _logoutClientSide();
    } finally {
      await checkLogin();
    }
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
        "userId": _userId,
      });
    }
  }
}
