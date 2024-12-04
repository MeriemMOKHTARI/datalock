import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import '../config/config.dart';

class AuthService {
    String? ipAddress ;

 

    Future <String> sendSMS(String phoneNumber,String platform,String ipAdresseUser,String entry_id, Account account, Databases databases) async {
    Client client = Client()
        .setEndpoint(Config.appwriteEndpoint)
        .setProject(Config.appwriteProjectId)
        .setSelfSigned(status: true);
    Functions functions = Functions(client);
    
    try {
      Execution result = await functions.createExecution(
        functionId: Config.SEND_SMS_FUNCTION_ID,
        body: json.encode({
          "phoneNumber": phoneNumber,
          "platform": platform,
          "ipAdresseUser": ipAdresseUser,
          "entry_id": entry_id
        }),
      );
     
      if (result.status == 'completed') {
        final responseBody = json.decode(result.responseBody);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
         print(responseBody.error);
        if (responseBody['status'] == 200) {
          return '200';
            // Handle successful SMS send
          print('SMS sent successfully');
        } else if (responseBody['status'] == 333){ 
          return '333';
          // Handle SMS send failure
          print('blocked user');
        }else {
          return '401';
        }
      } else {
        print('Function execution failed: ${result.status}' );
      return '401';
      }
    } catch (e) {
      // Handle error
            return '401';
      print('Error sending SMS: $e');
    
    }
  }




  void startCountdown(int seconds, Function(String) updateTime) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
        final minutes = seconds ~/ 60;
        final secs = seconds % 60;
        updateTime('$minutes:${secs.toString().padLeft(2, '0')}');
      } else {
        timer.cancel();
        updateTime('');
      }
    });
  }

  

  
}
