import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';


class Utils {
  static formatAddress(String address) {
    return "ak_***" + address.substring(address.length - 4, address.length);
  }

  static formatHomeAddress(String address) {
    return "ak_" + address.substring(3, 8) + "...." + address.substring(address.length - 8, address.length);
  }

  static formatPrice(String price) {
    return price.substring(0, price.length - 3);
  }

  // md5 加密
  static List<int> generateMd5Int(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return digest.bytes;
  }

  //aes加密
  static String aesEncode(String content,List<int> password ) {
    try {
      final key = Key.fromBase64(base64Encode(password));
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      final encrypted = encrypter.encrypt(content, iv: IV.fromBase64(base64Encode(password)));
      return encrypted.base64;
    } catch (err) {
      print("aes encode error:$err");
      return content;
    }
  }

  //aes解密
  static dynamic aesDecode(dynamic base64,List<int> password) {
    try {
      final key = Key.fromBase64(base64Encode(password));
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      return encrypter.decrypt64(base64, iv: IV.fromBase64(base64Encode(password)));
    } catch (err) {
      print("aes decode error:$err");
      return "";
    }
  }

  static String formatHeight(int startHeight, int endHeight) {
    var height = endHeight - startHeight;
    if (height < 1) {
      return "3分钟";
    }
    //秒
    var time = height * 3;
    if (time > 60 * 24) {
      return (time / (60 * 24)).toInt().toString() + "天";
    }
    if (time > 60) {
      return (time / (60)).toInt().toString() + "小时";
    }
    return (time).toInt().toString() + "分钟";
  }
}
