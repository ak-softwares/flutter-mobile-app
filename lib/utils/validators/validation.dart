
import 'dart:math';

class Validator {

  static bool isEmail(String value) {
    // Regular expression for validating an email address
    final RegExp regex = RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
        caseSensitive: false,
        multiLine: false
    );
    return regex.hasMatch(value);
  }

  /// Formats phone number for WhatsApp OTP
  ///
  /// [countryCode] - Country code (e.g., "+91", "1")
  /// [phoneNumber] - Raw phone number input
  ///
  /// Returns formatted phone number in E.164 format
  /// Throws [FormatException] if phone number is invalid
  static String formatPhoneNumberForWhatsAppOTP({required String countryCode,required String phoneNumber}) {
    // Remove all non-digit characters from both inputs
    final cleanedCountryCode = countryCode.replaceAll(RegExp(r'[^0-9]'), '');
    final cleanedPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    // Validate inputs
    if (cleanedCountryCode.isEmpty) {
      throw FormatException('Country code is required');
    }

    if (cleanedPhoneNumber.isEmpty) {
      throw FormatException('Phone number is required');
    }

    // Check if phone number starts with 0 (common in some countries)
    String finalPhoneNumber = cleanedPhoneNumber;
    if (finalPhoneNumber.startsWith('0')) {
      finalPhoneNumber = finalPhoneNumber.substring(1);
    }

    // Combine country code and phone number
    final formattedNumber = cleanedCountryCode + finalPhoneNumber;

    // Basic validation for minimum length
    // WhatsApp requires numbers in E.164 format (min length varies by country)
    if (formattedNumber.length < 8 || formattedNumber.length > 15) {
      throw FormatException('Invalid phone number length');
    }

    return formattedNumber;
  }

  static String? getFormattedTenDigitNumber(String phone) {
    // Remove spaces, '+', '(', ')', and black spaces
    String cleanedPhone = phone.replaceAll(RegExp(r'[\s+\(\)]'), '');

    // Extract last 10 digits
    String tenDigitNumber = cleanedPhone.substring(max(0, cleanedPhone.length - 10));

    return tenDigitNumber.length == 10 ? tenDigitNumber : null;
  }

  static String? validatePhoneNumber(String? value, {String? countryCode}) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove all non-digit characters
    final cleanedNumber = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Validate the cleaned number
    if (cleanedNumber.isEmpty) {
      return 'Invalid phone number format';
    }

    // Country-specific validation if country code is provided
    if (countryCode != null) {
      final cleanedCountryCode = countryCode.replaceAll(RegExp(r'[^0-9]'), '');

      // India-specific validation (+91)
      if (cleanedCountryCode == '91') {
        if (cleanedNumber.length != 10) {
          return 'Invalid: 10 digit number required for India';
        }
        if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleanedNumber)) {
          return 'Invalid Indian mobile number';
        }
      }
      // US/Canada-specific validation (+1)
      else if (cleanedCountryCode == '1') {
        if (cleanedNumber.length != 10) {
          return 'Invalid: 10 digit number required (including area code)';
        }
      }
      // Generic international validation
      else {
        if (cleanedNumber.length < 5 || cleanedNumber.length > 15) {
          return 'Invalid phone number length for this country';
        }
      }
    }
    // Generic validation when no country code is provided
    else {
      if (cleanedNumber.length < 5 || cleanedNumber.length > 15) {
        return 'Phone number should be 5-15 digits';
      }
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if(value == null || value.isEmpty) {
      return 'Email is required.';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$");

    if(!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if(value == null || value.isEmpty) {
      return 'Password is required.';
    }

    //Check for minimum password lenth
    if(value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    // //Check for uppercase letters
    // if(!value.contains(RegExp(r'[0-9]'))) {
    //   return 'Password must contain at least one number.';
    // }
    //
    // //Check for special characters
    // if(!value.contains(RegExp(r'[!@#%^&*()_+-=[]{}|;:",./<>?~`]'))){
    //   return 'Password must contain at least one special character.';
    // }

    return null;
  }

  static String? validatePinCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pincode is required';
    }

    // Regular expression to match exactly six digits
    RegExp pinCodeRegex = RegExp(r'^\d{6}$');

    if (!pinCodeRegex.hasMatch(value)) {
      return 'Pincode must be a 6-digit number';
    }

    return null;
  }

  static String? validateEmptyText(String? fieldName, String? value) {
    if(value == null || value.isEmpty){
      return '$fieldName is required';
    }
    return null;
  }

}





