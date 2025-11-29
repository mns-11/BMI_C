import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  var str = await fetchAlbum();
  print(str);

  // final f1 = Future(() {
  //   print("hello");
  // }); //الفيوتشر هو عبارة عن شي راح تعمله مستقبلا مش الان..

  // print("world");
  // print("object");
  // print("object1");
}

//APi دالة راح تجيب بيانات من الانترنت هنا GET;
Future<dynamic> fetchAlbum() async {
  final url = 'https://jsonplaceholder.typicode.com/albums';
  final res = await http.get(Uri.parse(url));

  if (res.statusCode == 200) {
    var obj = json.decode(res.body);
    // return response.body;
    for (var i = 0; i < obj.length; i++) {
      final album = obj[i];
      print('userId: ${album["userId"]}');
      print('id: ${album["id"]}');
      print('title: ${album["title"]}');
      print('---');
    }
    // return obj[0]["title"];
  } else {
    throw Exception('Failed to load album');
  }
}
