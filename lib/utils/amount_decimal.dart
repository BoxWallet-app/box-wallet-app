import 'package:decimal/decimal.dart';

class AmountDecimal {
  static String parseUnits(String amount, int decimal) {
    try {
      if (decimal == null) {
        decimal = 18;
      }
      if (decimal == 0) {
        return (Decimal.parse(amount)).toString();
      }

      String decimalStr = "1";
      for (var i = 0; i < decimal; i++) {
        decimalStr = decimalStr + "0";
      }
      // print((Decimal.parse(amount) / Decimal.parse(decimalStr)).toString());
      // print((double.parse(amount) / double.parse(decimalStr)).toString());
      // return (Decimal.parse(amount) / Decimal.parse(decimalStr)).toString();
      return (double.parse(amount) / double.parse(decimalStr)).toString();
    } catch (e) {
      return "0";
    }
  }
}
