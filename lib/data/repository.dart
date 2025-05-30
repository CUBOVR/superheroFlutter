import 'dart:convert';

import 'package:superhero_app/data/model/superheroResponse.dart';
import 'package:http/http.dart' as http;

class Repository {
  final String accessToken = "4dc57526a0a1e0a7999611929ca21417";

  Future<SuperheroResponse?> fetchSuperheroInfo(String name) async {
    final response = await http.get(
      Uri.parse("https://superheroapi.com/api/$accessToken/search/$name"),
    );

    if (response.statusCode == 200) {
      var decodedJson = jsonDecode(response.body);
      SuperheroResponse superheroResponse = SuperheroResponse.fromJson(
        decodedJson,
      );
      return superheroResponse;
    } else {
      return null;
    }
  }
}
