import 'package:firezup/data/validation_result.dart';

class ValidationUtils {
  final RegExp _emailRegMatcher = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final RegExp _uppercaseRegMatcher = RegExp(r'[A-Z]');
  final RegExp _lowercaseRegMatcher = RegExp(r'[a-z]');
  final RegExp _numberRegMatcher = RegExp(r'[0-9]');

  ValidationResult requiredString(String? val, String fieldName) {
    if (val!.isEmpty) {
      return ValidationResult(false, "$fieldName can not be empty");
    }
    return ValidationResult(true, null);
  }

  ValidationResult isEmail(String? val) {
    bool valid = _emailRegMatcher.hasMatch(val!);
    if (!valid) {
      return ValidationResult(false, "Please enter a valid email");
    }
    return ValidationResult(true, null);
  }

  ValidationResult isStrongPassword(String? val) {
    if (val!.isEmpty) {
      return ValidationResult(false, "Password can not be empty");
    }
    if (val.length < 6) {
      return ValidationResult(false, "Password length has to be longer than 6");
    }
    if (!val.contains(_uppercaseRegMatcher)) {
      return ValidationResult(
          false, "Password must contain at least 1 uppercase character");
    }
    if (!val.contains(_lowercaseRegMatcher)) {
      return ValidationResult(
          false, "Password must contain at least 1 lowercase character");
    }
    if (!val.contains(_numberRegMatcher)) {
      return ValidationResult(
          false, "Password must contain at least 1 numeric value");
    }

    return ValidationResult(true, null);
  }
}
