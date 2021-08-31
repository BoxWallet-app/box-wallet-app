import 'dart:convert';

import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:date_time_format/date_time_format.dart';

import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class Utils {
  // md5 加密
  static String generateMD5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

  static String cfxFormatAsFixed(String balance,int fixed) {
   if(fixed>0){
    return (double.parse(balance) / 1000000000000000000).toStringAsFixed(fixed);
   }else{
     return (double.parse(balance) / 1000000000000000000).toString();
   }
  }

  static formatAddress(String address) {
    if (address == "" || address.length <= 4) {
      return "";
    }
//    print(address);
    return "ak_..." + address.substring(address.length - 4, address.length);
  }

  static formatAccountAddress(String address) {
    if (address == "" || address.length <= 4) {
      return "";
    }
//    print(address);
    return  address.substring(0, 5) + "..." +  address.substring(address.length - 4, address.length);

  }
  static formatHomeCardAccountAddress(String address) {
    if (address == "" || address.length <= 4) {
      return "";
    }
//    print(address);
    //ak_ idk ...\nHKg j3q iCF
    return "ak_ " + address.substring(3, 6) + " "+address.substring(6, 9)+ " "+address.substring(9, 12)+"... \n" + address.substring(address.length - 9, address.length - 6) + " " + address.substring(address.length - 6, address.length - 3) + " " + address.substring(address.length - 3, address.length);
  }
  static formatHomeCardAccountAddressCFX(String address) {
    if (address == "" || address.length <= 4) {
      return "";
    }
//    print(address);
    //ak_ idk ...\nHKg j3q iCF
    return address.substring(0, 4) +" "+ address.substring(4, 6) + " "+address.substring(6, 9)+ " "+address.substring(9, 12)+"... \n" + address.substring(address.length - 9, address.length - 6) + " " + address.substring(address.length - 6, address.length - 3) + " " + address.substring(address.length - 3, address.length);
  }

  static formatHomeCardAddressCFX(String address) {
    if (address == "" || address.length <= 4) {
      return "";
    }
//    print(address);
    //ak_ idk ...\nHKg j3q iCF
    return  address.substring(0, 4) +" "+  address.substring(4, 6) +" "+  address.substring(6, 8)+ " ...\n" + address.substring(address.length - 9, address.length - 6) + " " + address.substring(address.length - 6, address.length - 3) + " " + address.substring(address.length - 3, address.length);
  }


  static formatHomeCardAddress(String address) {
    if (address == "" || address.length <= 4) {
      return "";
    }
//    print(address);
    //ak_ idk ...\nHKg j3q iCF
    return "ak_ " + address.substring(3, 6) + " ...\n" + address.substring(address.length - 9, address.length - 6) + " " + address.substring(address.length - 6, address.length - 3) + " " + address.substring(address.length - 3, address.length);
  }

  static getCurrentDate() {
    final dateTime = DateTime.now();
    return dateTime.format('D, M j, H:i');
  }

  static formatCTAddress(String address) {
    if (address == "" || address.length <= 4) {
      return "";
    }
//    print(address);
    return "ct_***" + address.substring(address.length - 4, address.length);
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
        } else {
          var base64decode = Utils.base64Decode(payload);
          return base64decode;
        }
      } catch (e) {
        return payload;
      }
    }
  }

  /*
  * Base64加密
  */
  static String encodeBase64(String data){
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
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
      return "";
    }
  }

  static String formatTime(time) {
    var now = new DateTime.now();
    var formatted = DateTime.fromMillisecondsSinceEpoch(time).toString();
    return formatted.substring(0, formatted.length - 7);
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

  static String formatABCLockV3Hint(String msg) {
    if (BoxApp.language == "cn") {
      if (msg.contains("IS_MAPPING_ACCOUNTS_BLACK_LIST_TRUE")) {
        return "当前账户已被加入黑名单";
      }
      if (msg.contains("IS_MAPPING_ACCOUNTS_TRUE")) {
        return "当前已存在映射合同";
      }
      if (msg.contains("MIN_LOCK_COUNT_LOW")) {
        return "映射AE数量过低";
      }
      if (msg.contains("BALANCE_COUNT_LOW")) {
        return "映射的AE数量不足";
      }
      if (msg.contains("IS_MAPPING_ACCOUNTS_FALSE")) {
        return "当前账户未存在映射";
      }
      if (msg.contains("MIN_BENEFITS_HEIGHT")) {
        return "未达到最低领取高度";
      }
      if (msg.contains("IS_MAPPING_ACCOUNTS_BLACK_LIST_FALSE")) {
        return "当前账户未在黑名单";
      }
      if (msg.contains("ACCOUNT_INSUFFICIENT_BALANCE")) {
        return "本期ABC已挖完";
      }
      return msg;
    } else {
      if (msg.contains("IS_MAPPING_ACCOUNTS_BLACK_LIST_TRUE")) {
        return "The current account has been blacklisted";
      }
      if (msg.contains("IS_MAPPING_ACCOUNTS_TRUE")) {
        return "A mapping contract currently exists";
      }
      if (msg.contains("MIN_LOCK_COUNT_LOW")) {
        return "The number of mapped AE is too low";
      }
      if (msg.contains("BALANCE_COUNT_LOW")) {
        return "Insufficient number of mapped AE";
      }
      if (msg.contains("IS_MAPPING_ACCOUNTS_FALSE")) {
        return "There is no mapping for the current account";
      }
      if (msg.contains("MIN_BENEFITS_HEIGHT")) {
        return "The minimum claim height was not reached";
      }
      if (msg.contains("IS_MAPPING_ACCOUNTS_BLACK_LIST_FALSE")) {
        return "The current account is not on the blacklist";
      }
      if (msg.contains("ACCOUNT_INSUFFICIENT_BALANCE")) {
        return "ABC mine over";
      }
      return msg;

      switch (msg) {
        case "IS_MAPPING_ACCOUNTS_BLACK_LIST_TRUE":
          return "";
        case "IS_MAPPING_ACCOUNTS_TRUE":
          return "";
        case "MIN_LOCK_COUNT_LOW":
          return "";
        case "BALANCE_COUNT_LOW":
          return "";
        case "IS_MAPPING_ACCOUNTS_FALSE":
          return "";
        case "MIN_BENEFITS_HEIGHT":
          return "";
        case "IS_MAPPING_ACCOUNTS_BLACK_LIST_FALSE":
          return "";
      }
      return msg;
    }
  }

  static String formatSwapV2Hint(String msg) {
    if (BoxApp.language == "cn") {
      if (msg.contains("IS_COIN_EXIST_F")) return "交易对不存在";
      if (msg.contains("IS_COIN_ACCOUNT_EXIST_T")) return "同一积分只可以挂单一次";
      if (msg.contains("LOW_TOKEN_COUNT_LOW_T")) return "未达到最低挂单积分标准";
      if (msg.contains("LOW_AE_COUNT_LOW_T")) return "未达到最低挂单AE标准";
      if (msg.contains("COIN_FRE")) return "积分已暂停兑换";
      if (msg.contains("IS_COIN_ACCOUNT_EXIST_FALSE")) return "挂单不存在";
      if (msg.contains("AE_VALUE_L")) return "AE数量过低";
    } else {
      if (msg.contains("IS_COIN_EXIST_F")) return "Trade pair does not exist";
      if (msg.contains("IS_COIN_ACCOUNT_EXIST_T")) return "The bill already exists";
      if (msg.contains("LOW_TOKEN_COUNT_LOW_T")) return "The number of credits is too low";
      if (msg.contains("LOW_AE_COUNT_LOW_T")) return "The number of AE is too low";
      if (msg.contains("COIN_FRE")) return "Bonus points have been suspended";
      if (msg.contains("IS_COIN_ACCOUNT_EXIST_FALSE")) return "The bill does not exist";
      if (msg.contains("AE_VALUE_L")) return "The number of AE is too low";
    }
    return msg;
  }
}
