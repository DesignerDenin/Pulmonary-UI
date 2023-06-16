import 'dart:convert';
import '../Utils/global.dart';
import 'package:http/http.dart' as http;

class Api{
  static predict(var file, var name) async {
    var req = http.MultipartRequest("POST", Uri.parse("$apiURL/predict"));
    req.files.add(await http.MultipartFile.fromBytes("file", file, filename: "$name.wav"));

    final res = await req.send();

    if(res.statusCode == 200) {
      final jsonRes = await res.stream.bytesToString();
      final jsonData = json.decode(jsonRes);
      return jsonData;
    }
    else {
      return null;
    }
  }
}