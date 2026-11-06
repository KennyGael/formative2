/// Form validators, kept as plain functions so they are easy to unit test.
class Validators {
  static String? name(String? v) {
    if (v == null || v.trim().length < 2) return 'Enter your full name';
    return null;
  }

  static String? email(String? v) {
    final t = v?.trim() ?? '';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t);
    return ok ? null : 'Enter a valid email';
  }

  static String? password(String? v) {
    if (v == null || v.length < 6) return 'At least 6 characters';
    return null;
  }

  static String? confirm(String? v, String password) {
    if (v == null || v.isEmpty) return 'Confirm your password';
    if (v != password) return 'Passwords do not match';
    return null;
  }
}
