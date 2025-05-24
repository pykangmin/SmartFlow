// 재무상태표 모델
class BalanceSheet {
  // 자산
  final double cash; // 현금/예금
  final double accounts_receivable; // 외상매출금
  final double inventory; // 재고자산
  final double fixed_assets; // 고정자산
  
  // 부채
  final double accounts_payable; // 외상매입금
  final double short_term_debt; // 단기차입금
  final double long_term_debt; // 장기차입금
  
  // 자본
  final double capital; // 자본금
  final double retained_earnings; // 이익잉여금
  final DateTime date;

  BalanceSheet({
    required this.cash,
    required this.accounts_receivable,
    required this.inventory,
    required this.fixed_assets,
    required this.accounts_payable,
    required this.short_term_debt,
    required this.long_term_debt,
    required this.capital,
    required this.retained_earnings,
    required this.date,
  });

  // 총자산
  double get total_assets => cash + accounts_receivable + inventory + fixed_assets;
  
  // 총부채
  double get total_liabilities => accounts_payable + short_term_debt + long_term_debt;
  
  // 총자본
  double get total_equity => capital + retained_earnings;
  
  // 유동비율 (유동자산/유동부채)
  double get current_ratio => (cash + accounts_receivable + inventory) / (accounts_payable + short_term_debt);
  
  // 부채비율 (총부채/총자본)
  double get debt_ratio => total_liabilities / total_equity;
}

// 손익계산서 모델
class IncomeStatement {
  final double revenue; // 매출액
  final double cost_of_goods_sold; // 매출원가
  final double operating_expenses; // 판매비와관리비
  final double other_income; // 영업외수익
  final double other_expenses; // 영업외비용
  final double tax_expense; // 법인세비용
  final DateTime start_date;
  final DateTime end_date;
  final String period; // "weekly", "monthly", "yearly"

  IncomeStatement({
    required this.revenue,
    required this.cost_of_goods_sold,
    required this.operating_expenses,
    required this.other_income,
    required this.other_expenses,
    required this.tax_expense,
    required this.start_date,
    required this.end_date,
    required this.period,
  });

  // 매출총이익
  double get gross_profit => revenue - cost_of_goods_sold;
  
  // 영업이익
  double get operating_profit => gross_profit - operating_expenses;
  
  // 법인세차감전순이익
  double get profit_before_tax => operating_profit + other_income - other_expenses;
  
  // 당기순이익
  double get net_profit => profit_before_tax - tax_expense;
  
  // 매출총이익률
  double get gross_margin => revenue > 0 ? (gross_profit / revenue) * 100 : 0;
  
  // 영업이익률
  double get operating_margin => revenue > 0 ? (operating_profit / revenue) * 100 : 0;
  
  // 순이익률
  double get net_margin => revenue > 0 ? (net_profit / revenue) * 100 : 0;
}

// 현금흐름표 모델
class CashFlowStatement {
  final double operating_cash_flow; // 영업활동 현금흐름
  final double investing_cash_flow; // 투자활동 현금흐름  
  final double financing_cash_flow; // 재무활동 현금흐름
  final double beginning_cash; // 기초현금
  final DateTime start_date;
  final DateTime end_date;
  final String period;

  CashFlowStatement({
    required this.operating_cash_flow,
    required this.investing_cash_flow,
    required this.financing_cash_flow,
    required this.beginning_cash,
    required this.start_date,
    required this.end_date,
    required this.period,
  });

  // 총현금흐름
  double get total_cash_flow => operating_cash_flow + investing_cash_flow + financing_cash_flow;
  
  // 기말현금
  double get ending_cash => beginning_cash + total_cash_flow;
  
  // 자유현금흐름
  double get free_cash_flow => operating_cash_flow + investing_cash_flow;
}

// 재무비율 분석
class FinancialRatios {
  final BalanceSheet balanceSheet;
  final IncomeStatement incomeStatement;
  final CashFlowStatement cashFlowStatement;

  FinancialRatios({
    required this.balanceSheet,
    required this.incomeStatement,
    required this.cashFlowStatement,
  });

  // 수익성 비율
  double get return_on_equity => balanceSheet.total_equity > 0 
      ? (incomeStatement.net_profit / balanceSheet.total_equity) * 100 : 0; // ROE
  
  double get return_on_assets => balanceSheet.total_assets > 0 
      ? (incomeStatement.net_profit / balanceSheet.total_assets) * 100 : 0; // ROA
  
  // 효율성 비율
  double get asset_turnover => balanceSheet.total_assets > 0 
      ? incomeStatement.revenue / balanceSheet.total_assets : 0; // 자산회전율
  
  // 안전성 비율
  double get interest_coverage_ratio => incomeStatement.other_expenses > 0 
      ? incomeStatement.operating_profit / incomeStatement.other_expenses : 0; // 이자보상비율
}

// 세무 정보
class TaxInfo {
  final double estimated_vat; // 예상 부가가치세
  final double estimated_income_tax; // 예상 종합소득세
  final double monthly_sales; // 월 매출
  final double annual_sales; // 연 매출
  final DateTime calculation_date;

  TaxInfo({
    required this.estimated_vat,
    required this.estimated_income_tax,
    required this.monthly_sales,
    required this.annual_sales,
    required this.calculation_date,
  });

  // VAT 신고 기준 (월 매출 4,800만원 이상 시 간이과세 제외)
  bool get is_general_taxpayer => annual_sales >= 48000000;
  
  // 분기별 VAT 예상액
  double get quarterly_vat => estimated_vat * 3;
} 