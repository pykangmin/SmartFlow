import 'dart:io';
import 'package:flutter/material.dart';
import '../models/receipt.dart';
import '../services/api_service.dart';

class ReceiptProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Receipt> _receipts = [];
  bool _isLoading = false;
  String? _error;
  
  // Daily analysis data
  double _dailyRevenue = 0.0;
  double _dailyExpense = 0.0;
  int _dailyReceiptCount = 0;
  
  // Getters
  List<Receipt> get receipts => _receipts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get dailyRevenue => _dailyRevenue;
  double get dailyExpense => _dailyExpense;
  int get dailyReceiptCount => _dailyReceiptCount;

  // Upload receipt
  Future<void> uploadReceipt(File imageFile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.uploadReceipt(imageFile);
      
      // 임시로 로컬에 추가 (실제로는 서버에서 받아와야 함)
      final newReceipt = Receipt(
        imageUrl: result['filename'] ?? '',
        totalAmount: 0.0, // OCR로 추출된 금액
        receiptDate: DateTime.now(),
        createdAt: DateTime.now(),
      );
      
      _receipts.add(newReceipt);
      
      // 일일 분석 데이터 새로고침
      await loadDailyAnalysis(DateTime.now());
      
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load receipts
  Future<void> loadReceipts({DateTime? startDate, DateTime? endDate}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _receipts = await _apiService.getReceipts(
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load daily analysis
  Future<void> loadDailyAnalysis(DateTime date) async {
    try {
      final analysis = await _apiService.getDailyAnalysis(date);
      _dailyRevenue = analysis['total_revenue']?.toDouble() ?? 0.0;
      _dailyExpense = analysis['total_expense']?.toDouble() ?? 0.0;
      _dailyReceiptCount = analysis['receipt_count'] ?? 0;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Get today's receipts
  List<Receipt> getTodayReceipts() {
    final today = DateTime.now();
    return _receipts.where((receipt) {
      return receipt.receiptDate.year == today.year &&
             receipt.receiptDate.month == today.month &&
             receipt.receiptDate.day == today.day;
    }).toList();
  }

  // Get receipts for date range
  List<Receipt> getReceiptsForPeriod(DateTime start, DateTime end) {
    return _receipts.where((receipt) {
      return receipt.receiptDate.isAfter(start.subtract(const Duration(days: 1))) &&
             receipt.receiptDate.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Initialize with sample data for demo
  void initializeSampleData() {
    _receipts = [
      Receipt(
        id: 1,
        imageUrl: 'sample1.jpg',
        totalAmount: 25000,
        receiptDate: DateTime.now(),
        createdAt: DateTime.now(),
        items: [
          ReceiptItem(
            id: 1,
            name: '아메리카노',
            quantity: 2,
            unitPrice: 4500,
            totalPrice: 9000,
          ),
          ReceiptItem(
            id: 2,
            name: '카페라떼',
            quantity: 1,
            unitPrice: 5500,
            totalPrice: 5500,
          ),
        ],
      ),
      Receipt(
        id: 2,
        imageUrl: 'sample2.jpg',
        totalAmount: 15000,
        receiptDate: DateTime.now().subtract(const Duration(hours: 2)),
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
    
    _dailyRevenue = 40000;
    _dailyExpense = 0;
    _dailyReceiptCount = 2;
    
    notifyListeners();
  }
} 