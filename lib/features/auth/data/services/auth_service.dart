import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uniapp/core/widgets/app_snack_bar.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final _auth = Supabase.instance.client.auth;
  static Future<void> getUserName() async {}
  static Future<void> getUserEmail() async {}
  Future<User?> signUpUser({
    required String email,
    required String password,
    required String displayName,
    required BuildContext context,
  }) async {
    try {
      final response = await _auth.signUp(
        email: email,
        password: password,
        data: {'displayName': displayName},
      );
      return response.user;
    } catch (e) {
      if (context.mounted) {
        snackBar(text: e.toString(), context: context);
      }
      return null;
    }
  }

  Future<User?> signInUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final response = await _auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user;
    } catch (e) {
      if (context.mounted) {
        snackBar(text: e.toString(), context: context);
      }
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {}
  }

  static Future<void> forgotPassword() async {}
}
