
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:3000/api';

  static Future<List<dynamic>> getList(String path) async {
    final response = await http
        .get(Uri.parse('$baseUrl/$path'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception(
        'โหลดข้อมูลไม่สำเร็จ (${response.statusCode})',
      );
    }

    final data = jsonDecode(response.body);

    if (data is! List) {
      throw Exception('รูปแบบข้อมูลจาก API ไม่ถูกต้อง');
    }

    return data;
  }

  static Future<List<dynamic>> getEmployees() {
    return getList('employees');
  }

  static Future<List<dynamic>> getPolicies() {
    return getList('policies');
  }
  
static Future<Map<String, dynamic>> getDashboard() async {
  final response = await http
      .get(Uri.parse('$baseUrl/dashboard'))
      .timeout(const Duration(seconds: 10));

  if (response.statusCode != 200) {
    throw Exception(
      'โหลดข้อมูลภาพรวมไม่สำเร็จ (${response.statusCode})',
    );
  }

  final data = jsonDecode(response.body);

  if (data is! Map<String, dynamic>) {
    throw Exception('รูปแบบข้อมูล Dashboard ไม่ถูกต้อง');
  }

  return data;
}
}