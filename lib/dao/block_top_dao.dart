import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/block_top_model.dart';
import 'package:http/http.dart' as http;

class BlockTopDao {
  static Future<BlockTopModel> fetch() async {
    final response = await http.post(BLOCK_TOP);
    if (response.statusCode != 200) {
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      BlockTopModel model = BlockTopModel.fromJson(result);
      return model;
    } else {
      throw Exception('Failed to load BlockTopModel.json');
    }
  }
}
