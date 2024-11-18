import 'package:http/src/response.dart';

import '../utils/auth_api_helper.dart';

class RegisterViewModel {
  final AuthApiHelper _authApiHelper = AuthApiHelper();

  Future<Response> sendAuthCode(String email) async {
    return await _authApiHelper.sendAuthCode(email);
  }
  Future<bool> sendResetAuthCode(String email) async {
    return await _authApiHelper.sendResetAuthCode(email);
  }
  Future<Response> checkPreviousPassword(String email, String password) async {
    return await _authApiHelper.checkPreviousPassword(email, password);
  }
  Future<bool> resetPassword(String email, String password) async {
    return await _authApiHelper.resetPassword(email, password);
  }
  Future<bool> verifyAuthCode(String email, String code) async {
    return await _authApiHelper.verifyAuthCode(email, code);
  }

  Future<bool> registerUser(String email, String password, String nickname) async {
    return await _authApiHelper.registerUser(email, password, nickname);

  }

}
