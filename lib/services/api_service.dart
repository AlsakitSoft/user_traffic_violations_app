import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/violation.dart';
import '../models/vehicle.dart';
import '../models/user.dart';

class ApiService {
  static const String _baseUrl =
      'http://192.168.173.96:7204/api'; // Replace with your actual API base URL
  String? _authToken;

  void setAuthToken(String? token) {
    _authToken = token;
  }

  Map<String, String> _getHeaders({bool includeAuth = true}) {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    if (includeAuth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');
    try {
      final response = await http.post(
        url,
        headers: _getHeaders(includeAuth: false),
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _authToken = data['token'];
        return data;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'فشل تسجيل الدخول');
      }
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }

  Future<List<Violation>> getViolationsForCitizen(String citizenId) async {
    final url = Uri.parse('$_baseUrl/violations/citizen/$citizenId');
    try {
      final response = await http.get(
        url,
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Violation.fromJson(json)).toList();
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'فشل جلب المخالفات');
      }
    } catch (e) {
      print('Error fetching violations: $e');
      rethrow;
    }
  }

  Future<List<Vehicle>> getVehiclesForUser(String userId) async {
    final url = Uri.parse('$_baseUrl/vehicles/user/$userId');
    try {
      final response = await http.get(
        url,
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Vehicle.fromJson(json)).toList();
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'فشل جلب المركبات');
      }
    } catch (e) {
      print('Error fetching vehicles: $e');
      rethrow;
    }
  }

  Future<User?> getUserDetails(String userId) async {
    final url = Uri.parse('$_baseUrl/users/$userId');
    try {
      final response = await http.get(
        url,
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      } else if (response.statusCode == 404) {
        return null; // User not found
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'فشل جلب تفاصيل المستخدم');
      }
    } catch (e) {
      print('Error fetching user details: $e');
      rethrow;
    }
  }

  Future<Violation?> getViolationDetails(String violationId) async {
    final url = Uri.parse('$_baseUrl/violations/$violationId');
    try {
      final response = await http.get(
        url,
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Violation.fromJson(data);
      } else if (response.statusCode == 404) {
        return null; // Violation not found
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'فشل جلب تفاصيل المخالفة');
      }
    } catch (e) {
      print('Error fetching violation details: $e');
      rethrow;
    }
  }

  Future<bool> updateViolationStatus(
      String violationId, String newStatus) async {
    final url = Uri.parse('$_baseUrl/violations/$violationId/status');
    try {
      final response = await http.put(
        url,
        headers: _getHeaders(),
        body: json.encode({
          'status': newStatus,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'فشل تحديث حالة المخالفة');
      }
    } catch (e) {
      print('Error updating violation status: $e');
      rethrow;
    }
  }
}
