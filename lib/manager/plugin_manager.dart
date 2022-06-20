import 'package:flutter/services.dart';

class PluginManager {
  static const MethodChannel _channel =
  const MethodChannel('BOX_DART_TO_NAV');

  static Future<String?> pushCfxWebViewActivity(Map params) async {
    String? resultStr = await _channel.invokeMethod('CfxWebViewActivity', params);
    return resultStr;
  }
  static Future<String?> cfxGetGas(Map params) async {
    String? resultStr = await _channel.invokeMethod('CfxGetGas', params);
    return resultStr;
  }
  static Future<String?> cfxSignTransaction(Map params) async {
    String? resultStr = await _channel.invokeMethod('CfxSignTransaction', params);
    return resultStr;
  }
  static Future<String?> passwordError(Map params) async {
    String? resultStr = await _channel.invokeMethod('passwordError', params);
    return resultStr;
  }
}