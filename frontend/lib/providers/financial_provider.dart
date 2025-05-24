import 'package:flutter/foundation.dart';
import '../models/financial_statement.dart';

class FinancialProvider with ChangeNotifier {
  List<BalanceSheet> _balanceSheets = [];
  List<IncomeStatement> _incomeStatements = [];
  List<CashFlowStatement> _cashFlowStatements = [];
  List<TaxInfo> _taxInfos = [];

  // Getters
  List<BalanceSheet> get balanceSheets => _balanceSheets;
  List<IncomeStatement> get incomeStatements => _incomeStatements;
  List<CashFlowStatement> get cashFlowStatements => _cashFlowStatements;
  List<TaxInfo> get taxInfos => _taxInfos;

  // 최신 재무상태표
  BalanceSheet? get latestBalanceSheet => 
      _balanceSheets.isNotEmpty ? _balanceSheets.last : null;

  // 월간 손익계산서들
  List<IncomeStatement> get monthlyIncomeStatements => 
      _incomeStatements.where((statement) => statement.period == 'monthly').toList();

  // 연간 손익계산서들  
  List<IncomeStatement> get yearlyIncomeStatements => 
      _incomeStatements.where((statement) => statement.period == 'yearly').toList();

  // 샘플 데이터 초기화
  void initializeSampleFinancialData() {
    _generateSampleBalanceSheets();
    _generateSampleIncomeStatements(); 
    _generateSampleCashFlowStatements();
    _generateSampleTaxInfo();
    notifyListeners();
  }

  void _generateSampleBalanceSheets() {
    final now = DateTime.now();
    
    // 최근 6개월 재무상태표
    for (int i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      _balanceSheets.add(BalanceSheet(
        cash: 3000000 + (i * 200000), // 현금 증가 추세
        accounts_receivable: 1200000 + (i * 50000),
        inventory: 800000 + (i * 30000),
        fixed_assets: 15000000,
        accounts_payable: 600000 + (i * 20000),
        short_term_debt: 2000000,
        long_term_debt: 5000000,
        capital: 10000000,
        retained_earnings: 2400000 + (i * 260000), // 누적 이익
        date: date,
      ));
    }
  }

  void _generateSampleIncomeStatements() {
    final now = DateTime.now();
    
    // 월간 손익계산서 (최근 12개월)
    for (int i = 11; i >= 0; i--) {
      final startDate = DateTime(now.year, now.month - i, 1);
      final endDate = DateTime(now.year, now.month - i + 1, 0);
      
      final baseRevenue = 4000000 + (500000 * (12 - i)); // 매출 성장
      
      _incomeStatements.add(IncomeStatement(
        revenue: baseRevenue * (0.9 + (0.2 * (12 - i) / 12)), // 성장 추세
        cost_of_goods_sold: baseRevenue * 0.4, // 매출원가율 40%
        operating_expenses: baseRevenue * 0.35, // 운영비율 35%
        other_income: 50000,
        other_expenses: 100000, // 이자비용 등
        tax_expense: baseRevenue * 0.05, // 세금 5%
        start_date: startDate,
        end_date: endDate,
        period: 'monthly',
      ));
    }

    // 연간 손익계산서 (최근 3년)
    for (int i = 2; i >= 0; i--) {
      final year = now.year - i;
      final startDate = DateTime(year, 1, 1);
      final endDate = DateTime(year, 12, 31);
      
      final annualRevenue = 45000000.0 + (i * 5000000.0); // 연간 성장
      
      _incomeStatements.add(IncomeStatement(
        revenue: annualRevenue,
        cost_of_goods_sold: annualRevenue * 0.4,
        operating_expenses: annualRevenue * 0.35,
        other_income: 600000,
        other_expenses: 1200000,
        tax_expense: annualRevenue * 0.05,
        start_date: startDate,
        end_date: endDate,
        period: 'yearly',
      ));
    }
  }

  void _generateSampleCashFlowStatements() {
    final now = DateTime.now();
    
    // 월간 현금흐름표 (최근 6개월)
    for (int i = 5; i >= 0; i--) {
      final startDate = DateTime(now.year, now.month - i, 1);
      final endDate = DateTime(now.year, now.month - i + 1, 0);
      
      _cashFlowStatements.add(CashFlowStatement(
        operating_cash_flow: 800000 + (i * 50000), // 영업 현금흐름 개선
        investing_cash_flow: -200000, // 투자로 인한 현금 유출
        financing_cash_flow: -150000, // 대출 상환
        beginning_cash: 2500000 + (i * 200000),
        start_date: startDate,
        end_date: endDate,
        period: 'monthly',
      ));
    }
  }

  void _generateSampleTaxInfo() {
    final now = DateTime.now();
    
    // 최근 분기 세무 정보
    for (int i = 3; i >= 0; i--) {
      final date = DateTime(now.year, now.month - (i * 3), 1);
      final quarterSales = 12000000 + (i * 500000);
      
      _taxInfos.add(TaxInfo(
        estimated_vat: quarterSales * 0.1, // 부가가치세 10%
        estimated_income_tax: quarterSales * 0.06, // 소득세 6%
        monthly_sales: quarterSales / 3,
        annual_sales: quarterSales * 4, // 연환산
        calculation_date: date,
      ));
    }
  }

  // 재무비율 계산
  FinancialRatios? getFinancialRatios() {
    if (latestBalanceSheet == null || 
        monthlyIncomeStatements.isEmpty || 
        _cashFlowStatements.isEmpty) {
      return null;
    }

    return FinancialRatios(
      balanceSheet: latestBalanceSheet!,
      incomeStatement: monthlyIncomeStatements.last,
      cashFlowStatement: _cashFlowStatements.last,
    );
  }

  // 매출 성장률 계산
  double getSalesGrowthRate() {
    if (monthlyIncomeStatements.length < 2) return 0;
    
    final current = monthlyIncomeStatements.last.revenue;
    final previous = monthlyIncomeStatements[monthlyIncomeStatements.length - 2].revenue;
    
    return previous > 0 ? ((current - previous) / previous) * 100 : 0;
  }

  // 예상 현금 부족일 계산
  int getDaysUntilCashShortage() {
    if (latestBalanceSheet == null || _cashFlowStatements.isEmpty) return -1;
    
    final currentCash = latestBalanceSheet!.cash;
    final monthlyCashFlow = _cashFlowStatements.last.total_cash_flow;
    
    if (monthlyCashFlow >= 0) return -1; // 현금이 증가하는 경우
    
    final dailyCashBurn = monthlyCashFlow.abs() / 30;
    return (currentCash / dailyCashBurn).floor();
  }

  // 업종별 벤치마크와 비교 (샘플 데이터)
  Map<String, double> getIndustryBenchmark() {
    return {
      'gross_margin': 35.0, // 업종 평균 매출총이익률
      'operating_margin': 12.0, // 업종 평균 영업이익률
      'current_ratio': 1.5, // 업종 평균 유동비율
      'debt_ratio': 0.6, // 업종 평균 부채비율
      'roe': 15.0, // 업종 평균 ROE
    };
  }
} 