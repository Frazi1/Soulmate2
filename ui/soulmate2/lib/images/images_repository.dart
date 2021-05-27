import 'dart:convert';

import 'package:soulmate2/images/models/image.dart';
import 'package:http/http.dart' as http;

class ImagesRepository {
  Future<List<ImageModel>> fetchImages([int startIndex = 0, int limit = 5]) async {
    final response = await http.get(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '/photos',
        <String, String>{'_start': '$startIndex', '_limit': '$limit'},
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        return ImageModel(json['id'] as int, json['url'] as String, false);
      }).toList();
    }
    throw Exception('error fetching images: ${response.statusCode}');
  }
}
