import 'dart:io';
import 'package:dio/dio.dart';
import '../models/receipt.dart';

class ApiService {
  static const String baseUrl = 'https://smartflow-gv1u.onrender.com';
  late Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 10),
    ));
  }

  Future<Map<String, dynamic>> uploadReceipt(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      Response response = await _dio.post(
        '/upload-receipt/',
        data: formData,
      );

      return response.data;
    } catch (e) {
      throw Exception('Failed to upload receipt: $e');
    }
  }

  Future<List<Receipt>> getReceipts({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Map<String, dynamic> queryParams = {};
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String();
      }

      Response response = await _dio.get(
        '/receipts/',
        queryParameters: queryParams,
      );

      List<dynamic> data = response.data;
      return data.map((json) => Receipt.fromJson(json)).toList();
    } catch (e) {
      // 임시로 빈 리스트 반환 (백엔드에 해당 엔드포인트가 없으므로)
      return [];
    }
  }

  Future<Map<String, dynamic>> getDailyAnalysis(DateTime date) async {
    try {
      Response response = await _dio.get(
        '/analysis/daily',
        queryParameters: {
          'date': date.toIso8601String().split('T')[0],
        },
      );

      return response.data;
    } catch (e) {
      // 임시 데이터 반환
      return {
        'total_revenue': 0.0,
        'total_expense': 0.0,
        'receipt_count': 0,
      };
    }
  }

  Future<Map<String, dynamic>> getWeeklyAnalysis(DateTime startDate) async {
    try {
      Response response = await _dio.get(
        '/analysis/weekly',
        queryParameters: {
          'start_date': startDate.toIso8601String().split('T')[0],
        },
      );

      return response.data;
    } catch (e) {
      // 임시 데이터 반환
      return {
        'total_revenue': 0.0,
        'total_expense': 0.0,
        'receipt_count': 0,
        'daily_breakdown': [],
      };
    }
  }

  Future<Map<String, dynamic>> getMonthlyAnalysis(int year, int month) async {
    try {
      Response response = await _dio.get(
        '/analysis/monthly',
        queryParameters: {
          'year': year,
          'month': month,
        },
      );

      return response.data;
    } catch (e) {
      // 임시 데이터 반환
      return {
        'total_revenue': 0.0,
        'total_expense': 0.0,
        'receipt_count': 0,
        'weekly_breakdown': [],
      };
    }
  }
} 