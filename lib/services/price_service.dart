import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:v4/data/mock/price_mockup_data.dart';

class PriceService {
  final String url = 'http://43.201.100.40:9001/prediction/price_info';

  Future<Map<String, dynamic>> fetchPriceInfo() async {
    try {
      // priceMockData의 'selectedCrops' 값을 그대로 반환
      return priceMockData['selectedCrops'] as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to load mock price data');
    }
  }
}

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class PriceService {
//   final String url = 'http://43.201.100.40:9001/prediction/price_info';

//   Future<Map<String, dynamic>> fetchPriceInfo() async {
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = json.decode(utf8.decode(response.bodyBytes));
//         return data;
//       } else {
//         print('Failed to load data. Status code: ${response.statusCode}');
//         return {};
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//       return {};
//     }
//   }
// }
