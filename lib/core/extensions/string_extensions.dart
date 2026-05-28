/// File: string_extensions.dart
/// Purpose: Provides utility extension methods on String.
library core;

extension StringExtensions on String {
  // Check if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  // Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  // Check if string contains only numbers
  bool get isNumeric {
    return double.tryParse(this) != null;
  }
}
