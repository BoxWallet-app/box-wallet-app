import 'package:flutter/services.dart';

class CustomTextFieldFormatter extends TextInputFormatter {
  static const defaultDouble = 0.001;

  ///允许的小数位数，-1代表不限制位数，默认为-1
  int digit;
  //重写构造方法，可以对位数进行直接限制
  CustomTextFieldFormatter({this.digit = -1});

  static double strToFloat(String str, [double defaultValue = defaultDouble]) {
    try {
      return double.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }

  ///获取目前的小数位数
  static int getValueDigit(String value) {
    if (value.contains(".")) {
      return value.split(".")[1].length;
    } else {
      return -1;
    }
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text;
    int selectionIndex = newValue.selection.end;
    // 如果输入框内容为.直接将输入框赋值为0.
    if (value == ".") {
      value = "0.";
      selectionIndex++;
      // 如果输入框内容为-号，也是被允许的，但是需要正则表达式的时候进行处理一下，允许-号被使用
    } else if (value == "-") {
      value = "-";
      selectionIndex++;
      // 输入内容不能为空，并且输入内容不能为0.001等条件的判断
    } else if (value != "" && value != defaultDouble.toString() && strToFloat(value, defaultDouble) == defaultDouble || getValueDigit(value) > digit) {
      value = oldValue.text;
      selectionIndex = oldValue.selection.end;
    }
    // 通过最上面的判断，这里返回的都是有限金额形式
    return new TextEditingValue(
      text: value,
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
