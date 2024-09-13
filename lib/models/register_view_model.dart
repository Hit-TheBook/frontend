import '../utils/auth_api_helper.dart';

class RegisterViewModel {
  final AuthApiHelper _authApiHelper = AuthApiHelper();

  Future<bool> sendAuthCode(String email) async {
    return await _authApiHelper.sendAuthCode(email);
  }

  Future<bool> verifyAuthCode(String email, String code) async {
    return await _authApiHelper.verifyAuthCode(email, code);
  }

  Future<bool> registerUser(String email, String password, String username) async {
    return await _authApiHelper.registerUser(email, password, username);
  }
}
