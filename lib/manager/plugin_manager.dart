import 'package:flutter/services.dart';

class PluginManager {
  static const MethodChannel _channel =
  const MethodChannel('plugin_demo');

  static Future<String> pushFirstActivity(Map params) async {
    String resultStr = await _channel.invokeMethod('jumpToActivity', params);
    return resultStr;
  }
}