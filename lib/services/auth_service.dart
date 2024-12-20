import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
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
          "ipAdressUser": "255.255.255.255",
          "entry_id": entry_id
        }),
      );
      if (result.status == 'completed') {
        final responseBody = json.decode(result.responseBody);
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
       print('Error sending SMS: $e');
            return '401';
    }
  }

     // ignore: non_constant_identifier_names
     Future<String> VerifyOTP(String phoneNumber, String otp, Account account, Databases databases) async {
    Client client = Client()
        .setEndpoint(Config.appwriteEndpoint)
        .setProject(Config.appwriteProjectId)
        .setSelfSigned(status: true);
    Functions functions = Functions(client);
    try {
      print('Sending OTP verification request for phone: $phoneNumber, OTP: $otp');
      Execution result = await functions.createExecution(
        functionId: "6744a9f8001f83732f40",
        body: json.encode({
          "phoneNumber": phoneNumber,
          "otpInput": otp, // Changed from "otp" to "otpInput" to match expected input
        }),
      );
      print('Function execution status: ${result.status}');
      print('Function response body: ${result.responseBody}');
      
      if (result.status == 'completed') {
        final responseBody = json.decode(result.responseBody);
        print('Decoded response body: $responseBody');
        
        if (responseBody['status'] == '200') { // Changed from 200 to 'OK' to match potential string response
          return '200';
        } else if (responseBody['status'] == '400') {
          return '400';
        } else if (responseBody['status'] == '333') {
          return '333';
        }
        else {
                    return 'ERR';
        }
      } else {
        return 'ERR';
      }
    } catch (e) {
      return 'ERR';
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

  Future <String> saveUserInfos(String phoneNumber,String platform,String ipAdresseUser,String entry_id,String name,String familyname,String email, Account account, Databases databases) async {
    Client client = Client()
        .setEndpoint(Config.appwriteEndpoint)
        .setProject(Config.appwriteProjectId)
        .setSelfSigned(status: true);
    Functions functions = Functions(client);
    try {
      Execution result = await functions.createExecution(
        functionId: "saveUserInfo",
        body: json.encode({
          "phoneNumber": phoneNumber,
"user_id" : entry_id ,
"name" : name,
"familyName" : familyname , 
"platform_user" : platform ,
"ipadress_user" : "255.255.255.255" ,         
 "email": email  
        }),method: ExecutionMethod.pOST,
      );
      if (result.status == 'completed') {
        final responseBody = json.decode(result.responseBody);
        print(responseBody);
        if (responseBody['status'] == '400') {
            print('please provide all informations');
          return '400';
            // Handle successful 
        
        } else if (responseBody['status'] == '200'){ 
                    print('infos saved successfully');

          return '200';
          // Handle SMS send failure
        }else {
          return 'ERR';
        }
      } else {
        print('Function execution failed: ${result.status}' );
      return '401';
      }
    } catch (e) {
      // Handle error
       print('Error saving user infos: $e');
            return '401';
    }
  }


  Future <String> uploadUserSession(String phoneNumber,String entry_id, Account account, Databases databases) async {
    Client client = Client()
        .setEndpoint(Config.appwriteEndpoint)
        .setProject(Config.appwriteProjectId)
        .setSelfSigned(status: true);
    Functions functions = Functions(client);
    try {
      Execution result = await functions.createExecution(
        functionId: "sessionManagement",
        body: json.encode({
          "phoneNumber": phoneNumber,
          "userID": entry_id ,
        }),
      );
      if (result.status == 'completed') {
        final responseBody = json.decode(result.responseBody);
        if (responseBody['status'] == '200') {
          return '200';
          
        } else if (responseBody['status'] == '400'){ 
          return '400';
        }else {
          return 'ERR';
        }
      } else {
        print('Function execution failed: ${result.status}' );
      return '401';
      }
    } catch (e) {
      // Handle error
       print('Error : $e');
            return '401';
    }
  }
  
}
