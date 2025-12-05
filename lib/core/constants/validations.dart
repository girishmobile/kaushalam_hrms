String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email';
  }
  return null;
}

String? emptyError(
  String? value, {
  String errorMessage = "This field is required",
}) {
  if (value == null || value.isEmpty) {
    return errorMessage;
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

String? validateTenDigitPhone(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Phone number is required';
  }
  final input = value.trim();

  // सिर्फ digits allow करो
  final regExp = RegExp(r'^[0-9]{10}$');

  return regExp.hasMatch(input) ? null : 'Enter exactly 10 digits';
}

String? validateConfirmPassword(String? value, String password) {
  if (value == null || value.isEmpty) {
    return 'Confirm password is required';
  }
  if (value != password) {
    return 'Passwords do not match';
  }
  return null;
}
