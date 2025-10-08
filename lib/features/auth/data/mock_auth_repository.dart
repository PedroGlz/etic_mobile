import 'dart:async';

import 'package:etic_mobile/core/constants.dart';
import 'package:etic_mobile/features/auth/domain/credentials.dart';

class MockAuthRepository {
  Future<bool> login(Credentials credentials) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return credentials.email.trim() == AppConstants.demoEmail &&
        credentials.password == AppConstants.demoPassword;
  }

  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
  }
}
