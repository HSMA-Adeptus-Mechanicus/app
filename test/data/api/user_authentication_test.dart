import 'package:sff/data/api/user_authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

void main() async {

  await GetStorage.init();

  test("Register edit and delete account", () async {
    String username = "User Test";
    String password = "123";
    String newPassword = "abc";
    String newUsername = "User Test Renamed";
    
    final userAuth = UserAuthentication.getInstance();
    await userAuth.logout();
    await userAuth.register(username, password);
    expect(userAuth.authenticated, true);
    await userAuth.logout();
    await userAuth.login(username, password);
    await userAuth.editPassword(password, newPassword);
    password = newPassword;
    expect(userAuth.authenticated, false);
    await userAuth.login(username, password);
    expect(userAuth.authenticated, true);
    await userAuth.editUsername(password, newUsername);
    username = newUsername;
    await userAuth.checkLogin();
    expect(userAuth.authenticated, true);
    await userAuth.deleteAccount(password);
    expect(userAuth.authenticated, false);
  });
}
