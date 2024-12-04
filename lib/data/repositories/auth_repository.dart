import 'package:appwrite/appwrite.dart';
import '../models/user_model.dart';
import '../data_sources/auth_data_source.dart';

class AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepository(this._dataSource);

  // Future<String> createPhoneSession(String phone) async {
  //   return await _dataSource.createPhoneSession(phone);
  // }

  // Future<void> verifyPhoneSession(String userId, String otp) async {
  //   await _dataSource.verifyPhoneSession(userId, otp);
  // 
  }

