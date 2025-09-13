class Validators {
  static String? requiredField(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;

  static String? minLength(String? v, int min) =>
      (v == null || v.length < min) ? 'Minimum $min characters' : null;

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);
    return ok ? null : 'Enter a valid email';
  }
}
