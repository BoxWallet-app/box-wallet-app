import 'package:flutter/services.dart';

class PluginManager {
  static const MethodChannel _channel =
  const MethodChannel('BOX_DART_TO_NAV');

  static Future<String> pushActivity(Map params) async {
    String resultStr = await _channel.invokeMethod('jumpToActivity', params);
    return resultStr;
  }
  static Future<String> getGasCFX(Map params) async {
    String resultStr = await _channel.invokeMethod('getGasCFX', params);
    return resultStr;
  }
  static Future<String> signTransaction(Map params) async {
    String resultStr = await _channel.invokeMethod('signTransaction', params);
    return resultStr;
  }
  static Future<String> signTransactionError(Map params) async {
    String resultStr = await _channel.invokeMethod('signTransactionError', params);
    return resultStr;
  }
}