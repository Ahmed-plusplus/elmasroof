import 'package:elmasroof/shared/formatter/formatter.dart';

class DecimalFormatter extends Formatter{

  DecimalFormatter();

  @override
  RegExp patternInputFormatter() {
    return RegExp(r'^-$|^-?(0|[1-9][0-9]*)(\.[0-9]*)?$');
  }

  @override
  RegExp patternFormatter() {
    return RegExp(r'^-?(0|[1-9][0-9]*)(\.[0-9]*[1-9])?$');
  }

}