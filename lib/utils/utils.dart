import 'dart:convert';

import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert' as convert;

import 'package:flutter/material.dart';

class Utils {
  static formatAddress(String address) {
    if(address == ""|| address.length<=4){
      return "";
    }
//    print(address);
    return "ak_***" + address.substring(address.length - 4, address.length);
  }

  static formatHomeAddress(String address) {
    return "ak_" + address.substring(3, 8) + "...." + address.substring(address.length - 8, address.length);
  }

  static formatPayload(String payload) {

    if (payload != "" && payload != null && payload != "null") {
      try {
        if (payload.contains("ba_")) {
          var substring = payload.substring(3);
          var base64decode = Utils.base64Decode(substring);
          substring = base64decode.substring(0, base64decode.length - 4);
          return substring;
        }else{
          var base64decode = Utils.base64Decode(payload);
          return base64decode;
        }

      } catch (e) {
        return payload;
      }
    }
  }

  static formatPrice(String price) {
    return price.substring(0, price.length - 3);
  }

  static String base64Decode(String data) {
    List<int> bytes = convert.base64Decode(data);
    // 网上找的很多都是String.fromCharCodes，这个中文会乱码
    String txt1 = String.fromCharCodes(bytes);
//    String result = convert.utf8.decode(bytes);
    return txt1;
  }

  // md5 加密
  static List<int> generateMd5Int(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return digest.bytes;
  }

  //aes加密
  static String aesEncode(String content, List<int> password) {
    try {
      final key = encrypt.Key.fromBase64(base64Encode(password));
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
      final encrypted = encrypter.encrypt(content, iv: encrypt.IV.fromBase64(base64Encode(password)));
      return encrypted.base64;
    } catch (err) {
      print("aes encode error:$err");
      return content;
    }
  }

  //aes解密
  static dynamic aesDecode(dynamic base64, List<int> password) {
    try {
      final key = encrypt.Key.fromBase64(base64Encode(password));
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
      return encrypter.decrypt64(base64, iv: encrypt.IV.fromBase64(base64Encode(password)));
    } catch (err) {
      print("aes decode error:$err");
      return "";
    }
  }

  static String formatHeight(BuildContext context, int startHeight, int endHeight) {
    var height = endHeight - startHeight;
    if (height <= 0) {
      return "-";
    }
    if (height <= 1) {
      return "3" + S.of(context).common_points;
    }
    //秒
    var time = height * 3;
    if (time > 60 * 24) {
      return (time / (60 * 24)).toInt().toString() + S.of(context).common_day;
    }
    if (time > 60) {
      return (time / (60)).toInt().toString() + S.of(context).common_hours;
    }
    return (time).toInt().toString() + S.of(context).common_points;
  }
}
