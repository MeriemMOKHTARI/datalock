import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/config.dart';

class MapService {
  final storage = FlutterSecureStorage();

Future<Map<String, String>> addFavoriteAddress({
    required String label,
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    Client client = Client()
        .setEndpoint(Config.appwriteEndpoint)
        .setProject(Config.appwriteProjectId)
        .setSelfSigned(status: true);
    Functions functions = Functions(client);

    try {
      final userId = await storage.read(key: 'user_id');
      if (userId == null) {
        return {'status': '400', 'message': 'User ID not found'};
      }

      Execution result = await functions.createExecution(
        functionId: "manageFavoriteAddresses",
        body: json.encode({
          "user_id": userId,
          "label": label[0].toUpperCase(), // H for Home, W for Work, O for Others
          "address": address,
          "latitude": latitude,
          "longitude": longitude,
        }),
        method: ExecutionMethod.pOST,
      );

      if (result.status == 'completed') {
        final responseBody = json.decode(result.responseBody);
        print('addFavoriteAddress response: $responseBody');
        
        if (responseBody['status'] == '200') {
          print('Address added successfully');
          return {'status': '200'};
        } else if (responseBody['status'] == '400') {
          print('Missing required fields');
          return {'status': '400'};
        } else {
          return {'status': 'ERR'};
        }
      } else {
        print('Function execution failed: ${result.status}');
        return {'status': 'ERR'};
      }
    } catch (e) {
      print('Error in addFavoriteAddress: $e');
      return {'status': 'ERR'};
    }
  }

  Future<Map<String, dynamic>> getFavoriteAddresses() async {
    Client client = Client()
        .setEndpoint(Config.appwriteEndpoint)
        .setProject(Config.appwriteProjectId)
        .setSelfSigned(status: true);
    Functions functions = Functions(client);

    try {
      final userId = await storage.read(key: 'user_id');

      Execution result = await functions.createExecution(
        functionId: "manageFavoriteAddresses",
        body: json.encode({
          "user_id": userId,
        }),
        method: ExecutionMethod.gET,
      );

      if (result.status == 'completed') {
        final responseBody = json.decode(result.responseBody);
        print('getFavoriteAddresses response: $responseBody');
        
        if (responseBody['status'] == '200') {
          return {
            'status': '200',
            'data': responseBody['data'],
          };
        } else if (responseBody['status'] == '400') {
          return {'status': '400'};
        } else {
          return {'status': 'ERR'};
        }
      } else {
        print('Function execution failed: ${result.status}');
        return {'status': 'ERR'};
      }
    } catch (e) {
      print('Error in getFavoriteAddresses: $e');
      return {'status': 'ERR'};
    }
  }

  Future<Map<String, String>> updateFavoriteAddress({
    required String documentId,
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    Client client = Client()
        .setEndpoint(Config.appwriteEndpoint)
        .setProject(Config.appwriteProjectId)
        .setSelfSigned(status: true);
    Functions functions = Functions(client);

    try {
      Execution result = await functions.createExecution(
        functionId: "manageFavoriteAddresses",
        body: json.encode({
          "document_id": documentId,
          "address": address,
          "latitude": latitude,
          "longitude": longitude,
        }),
        method: ExecutionMethod.pUT,
      );

      if (result.status == 'completed') {
        final responseBody = json.decode(result.responseBody);
        print('updateFavoriteAddress response: $responseBody');
        
        if (responseBody['status'] == '200') {
          return {'status': '200'};
        } else if (responseBody['status'] == '400') {
          return {'status': '400'};
        } else {
          return {'status': 'ERR'};
        }
      } else {
        print('Function execution failed: ${result.status}');
        return {'status': 'ERR'};
      }
    } catch (e) {
      print('Error in updateFavoriteAddress: $e');
      return {'status': 'ERR'};
    }
  }

  Future<Map<String, String>> deleteFavoriteAddress(String documentId) async {
    Client client = Client()
        .setEndpoint(Config.appwriteEndpoint)
        .setProject(Config.appwriteProjectId)
        .setSelfSigned(status: true);
    Functions functions = Functions(client);

    try {
      Execution result = await functions.createExecution(
        functionId: "manageFavoriteAddresses",
        body: json.encode({
          "document_id": documentId,
        }),
        method: ExecutionMethod.dELETE,
      );

      if (result.status == 'completed') {
        final responseBody = json.decode(result.responseBody);
        print('deleteFavoriteAddress response: $responseBody');
        
        if (responseBody['status'] == '200') {
          return {'status': '200'};
        } else if (responseBody['status'] == '400') {
          return {'status': '400'};
        } else {
          return {'status': 'ERR'};
        }
      } else {
        print('Function execution failed: ${result.status}');
        return {'status': 'ERR'};
      }
    } catch (e) {
      print('Error in deleteFavoriteAddress: $e');
      return {'status': 'ERR'};
    }
  }
}