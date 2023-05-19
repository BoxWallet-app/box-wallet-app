import 'package:dio/dio.dart';

class NodeTestDao {
  static Future<bool> fetch(String nodeUrl) async {



    try{
      Response responseNode = await Dio().get(nodeUrl + "/v2/blocks/top");
      if (responseNode.statusCode != 200) {
        return false;
      }
      return true;
    }catch(e){
      print(e);
      return false;

    }

  }

}
