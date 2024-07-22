import 'package:fancy_content_creation_web/data/api_service.dart';
import 'package:fancy_content_creation_web/data/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final logInProvider = Provider<LoginLogic>((ref) {
  return LoginLogic(ref.read);
});

class LoginLogic {
  final Reader read;

  LoginLogic(this.read);

  Future<void> login(BuildContext context) async {
    const String email = 'nanonae@gmail.com';
    const String password = 'Skshso123!';

    try {
      final response = await read(apiServiceProvider).login(email, password);
      debugPrint(response.headers.toString());
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        debugPrint("0");
        final Map<String, dynamic> responseData =
            response.data as Map<String, dynamic>;
        debugPrint("1");
        debugPrint(responseData.toString());

        TokenStorage()
            .setTokens(responseData['access'], responseData['refresh']);
        debugPrint('Login successful');
        debugPrint('Access token: ${responseData['access']}');
        debugPrint('Refresh token: ${responseData['refresh']}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful')),
        );
      } else {
        final Map<String, dynamic> responseData =
            response.data as Map<String, dynamic>;
        debugPrint('Login failed: ${responseData['error']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${responseData['error']}')),
        );
      }
    } catch (e) {
      debugPrint('Login failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }
}
