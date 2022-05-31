import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:love_calculator/models/entities/ResponseEntity.dart';

class CalculatorRepository {
  Future<ResponseEntity> calculate(String yourName, String friendName) async {
    Map<String, String> headers = {
      'x-rapidapi-host': 'love-calculator.p.rapidapi.com',
      'x-rapidapi-key': '9182c6de5fmsh61e815d9d53e9e3p1c5d16jsn94867ec25c2f'
    };

    var response = await http.get(
        Uri.parse('https://love-calculator.p.rapidapi.com/getPercentage?fname=$yourName&sname=$friendName'), headers: headers);
    if (response.statusCode == 200) {
      return ResponseEntity.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
}
