import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/podcast.dart';

class ApiService {
  static Future<List<Podcast>> fetchPodcasts(String term) async {
    final response = await http.get(Uri.parse(
        'https://itunes.apple.com/search?term=$term&media=podcast&limit=20'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> results = data['results'];
      return results.map((json) => Podcast.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load podcasts');
    }
  }
}