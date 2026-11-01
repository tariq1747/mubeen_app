/// Shared, reusable form-field validators used across every screen.
class Validators {
  Validators._();

  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? amount(String? value, {String field = 'Amount'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    final parsed = double.tryParse(value.trim());
    if (parsed == null) return 'Enter a valid $field';
    if (parsed < 0) return '$field cannot be negative';
    return null;
  }

  static String? mobile(String? value) {
    if (value == null || value.trim().isEmpty) return 'Mobile number is required';
    if (value.trim().length < 7) return 'Enter a valid mobile number';
    return null;
  }
}
