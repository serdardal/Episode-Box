class FormHelper {
  static String? Function(String?) notEmptyTextValidator(String emptyMessage) {
    String? validator(String? value) {
      if (value == null || value.isEmpty) {
        return emptyMessage;
      }
      return null;
    }

    return validator;
  }

  static String? Function(String?) numericTextValidator() {
    String? validator(String? value) {
      if (value == null) {
        return null;
      }

      final numeric = RegExp(r'^[0-9]*$');
      if (!numeric.hasMatch(value)) {
        return 'Please enter decimal number only.';
      }

      return null;
    }

    return validator;
  }
}
