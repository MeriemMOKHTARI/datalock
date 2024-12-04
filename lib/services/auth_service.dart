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
        
        if (responseBody['status'] == 'OK') { // Changed from 200 to 'OK' to match potential string response
          print('OTP verification successful');
          return '200';
        } else if (responseBody['status'] == 'ERR') {
          print('OTP verification failed: ${responseBody['error']}');
          return '401';
        } else {
          print('Unexpected status in response: ${responseBody['status']}');
          return '500';
        }
      } else {
        print('Function execution failed: ${result.status}');
        return '500';
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      return '500';
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
