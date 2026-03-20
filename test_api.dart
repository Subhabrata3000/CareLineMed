import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print("Hitting REAL Digontom Search Doctor API with POST...");

  // Note: Based on your config.dart, the base URL includes /customer/
  // URL from config: https://admindoc.digontom.com/customer/search_doctor
  // But using the exact one you provided below:
  Uri apiUrl = Uri.parse('https://admindoc.digontom.com/customer/search_doctor');

  try {
    final response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        "text": "",
        "lat": "0.0",
        "lon": "0.0"
      }),
    );
    print("STATUS BYTE CODE: ${response.statusCode}");
    print("BODY:");
    print(response.body);
  } catch (e) {
    print("FAILED TO HIT API: $e");
  }
}
