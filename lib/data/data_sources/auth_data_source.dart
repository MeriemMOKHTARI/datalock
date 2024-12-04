import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import '../../config/config.dart';
import '../models/user_model.dart';

class AuthDataSource {
  final Account _account;
  final Databases _databases;
  final Functions _functions;

  AuthDataSource(this._account, this._databases, this._functions);

  // Future<String> createPhoneSession(String phone) async {
  //   try {
  //     final session = await _account.createPhoneSession(
  //       userId: ID.unique(),
  //       phone: phone,
  //     );
  //     return session.$id; // Return the session ID
  //   } catch (e) {
  //     throw Exception('Failed to create phone session: $e');
  //   }
  // }

  // Future<void> verifyPhoneSession(String userId, String otp) async {
  //   try {
  //     await _account.updatePhoneSession(
  //       userId: userId,
  //       secret: otp,
  //     );
  //   } catch (e) {
  //     throw Exception('Failed to verify phone session: $e');
  //   }
  // }

  Future<void> saveUserInfo(UserModel user) async {
    try {
      await _databases.createDocument(
        databaseId: Config.mainDatabaseId,
        collectionId: Config.collections['userAuth']!,
        documentId: ID.unique(),
        data: user.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to save user information: $e');
    }
  }

 

 
}

extension on Account {
  createPhoneSession({required String userId, required String phone}) {}
}

