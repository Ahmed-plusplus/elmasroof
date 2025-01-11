import 'package:elmasroof/shared/formatter/formatter.dart';

class GeneralFormatter extends Formatter{

  GeneralFormatter();

  @override
  RegExp patternInputFormatter() {
    return RegExp(r'.*');
  }

  @override
  RegExp patternFormatter() {
    return RegExp(r'.*');
  }

}