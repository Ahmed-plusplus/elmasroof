import 'package:elmasroof/shared/formatter/formatter.dart';
import 'package:flutter/services.dart';

class CustomPatternInputFormatter extends TextInputFormatter {
  final Formatter formatter;

  CustomPatternInputFormatter(this.formatter);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    RegExp regex = formatter.patternInputFormatter();
    // If the new value matches the regex, allow the change
    if (newValue.text.isEmpty || regex.hasMatch(newValue.text)) {
      return newValue;
    }
    // Otherwise, revert to the old value
    return oldValue;
  }
}
