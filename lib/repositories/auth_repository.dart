import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

const String projectId = '62d48e6e7fefcf36862e';
const String endPoint = 'http://10.0.2.2/v1';

class AuthenticationRepository {
  AuthenticationRepository() {
    _init();
  }

  final Client _client = Client();
  late Account _account;

  Future<User?> user() async {
    try {
      return await _account.get();
    } on AppwriteException catch (e) {
      if (e.type == 'general_unauthorized_scope') {
        return null;
      }
      rethrow;
    }
  }

  void _init() async {
    _client
        .setEndpoint(endPoint)
        .setProject(projectId)
        .setSelfSigned(status: true);
    _account = Account(_client);
  }

  Future<void> signInWithCredentials(
      String emailAddress, String password) async {
    try {
      await _account.createEmailSession(
          email: emailAddress, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _account.deleteSessions();
    } catch (e) {
      rethrow;
    }
  }
}
