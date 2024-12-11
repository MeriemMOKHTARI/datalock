import 'package:appwrite/appwrite.dart';
import '../config/config.dart';

class SessionService {
  late Client client;
  late Databases databases;
  static const String _databaseId = "671a5178001dbf2ebecd";
  static const String _collectionId = "6756fd40003d8191337e";

  SessionService() {
    client = Client()
      .setEndpoint(Config.appwriteEndpoint)
      .setProject(Config.appwriteProjectId)
      .setSelfSigned(status: true);
    databases = Databases(client);
  }

  Future<void> createUserSession(String userId, String phoneNumber) async {
    try {
      await databases.createDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: ID.unique(),
        data: {
          'user_id': userId,
          'phone_number': phoneNumber,
        },
      );
      print('User session created in Appwrite');
    } catch (e) {
      print('Error creating user session in Appwrite: $e');
      rethrow;
    }
  }

  Future<void> deleteUserSession(String userId) async {
    try {
      final response = await databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _collectionId,
        queries: [
          Query.equal('user_id', userId),
        ],
      );

      if (response.documents.isNotEmpty) {
        for (var doc in response.documents) {
          await databases.deleteDocument(
            databaseId: _databaseId,
            collectionId: _collectionId,
            documentId: doc.$id,
          );
        }
      }
      print('User session deleted from Appwrite');
    } catch (e) {
      print('Error deleting user session from Appwrite: $e');
      rethrow;
    }
  }

  Future<bool> checkUserSessionExists(String userId) async {
    try {
      final response = await databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _collectionId,
        queries: [
          Query.equal('user_id', userId),
        ],
      );
      return response.documents.isNotEmpty;
    } catch (e) {
      print('Error checking user session in Appwrite: $e');
      return false;
    }
  }
}

