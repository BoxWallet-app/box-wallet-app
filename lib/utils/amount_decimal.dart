import 'package:decimal/decimal.dart';

class AmountDecimal {
  static String parseUnits(String? amount, int decimal) {
    try {
      if (decimal == null) {
        decimal = 18;
      }
      if (decimal == 0) {
        return (Decimal.parse(amount!)).toString();
      }

      String decimalStr = "1";
      for (var i = 0; i < decimal; i++) {
        decimalStr = decimalStr + "0";
      }
      var amountData = (double.parse(amount!) / double.parse(decimalStr)).toStringAsFixed(6);
      var amountDataList = amountData.split(".");
      if (amountDataList.length > 1) {
        if (amountDataList[1].length > 6) {
          return (double.parse(amount) / double.parse(decimalStr)).toStringAsFixed(6);
        }
      } else {
        return parseDecimal(amountData);
      }
      return parseDecimal(amountData);
    } catch (e) {
      return "0";
    }
  }

  static String parseDecimal(String? amount) {
    try {
      var amountData = amount.toString();
      var amountDataList = amountData.split(".");
      if (amountDataList.length > 1) {
        if (amountDataList[1].length > 6) {
          return double.parse(amount!).toStringAsFixed(6);
        }
      } else {
        return double.parse(amountData).toString();
      }

      if (num.parse(amountData) % 1 == 0) {
        print("int");
        return double.parse(amountData).toStringAsFixed(0);
      } else {
        print("not int");
        return double.parse(amountData).toString();
      }
    } catch (e) {
      return "0";
    }
  }
}
