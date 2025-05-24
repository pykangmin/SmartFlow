import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/financial_provider.dart';
import '../models/financial_statement.dart';

class FinancialScreen extends StatefulWidget {
  @override
  _FinancialScreenState createState() => _FinancialScreenState();
}

class _FinancialScreenState extends State<FinancialScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FinancialProvider>(
      builder: (context, financialProvider, child) {
        return Scaffold(
          body: Column(
            children: [
              // 재무 탭 헤더
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: [
                    Tab(text: '재무상태'),
                    Tab(text: '손익계산'),
                    Tab(text: '현금흐름'),
                    Tab(text: '재무비율'),
                    Tab(text: '세무정보'),
                  ],
                ),
              ),
              
              // 탭 콘텐츠
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBalanceSheetTab(financialProvider),
                    _buildIncomeStatementTab(financialProvider),
                    _buildCashFlowTab(financialProvider),
                    _buildFinancialRatiosTab(financialProvider),
                    _buildTaxInfoTab(financialProvider),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 재무상태표 탭
  Widget _buildBalanceSheetTab(FinancialProvider provider) {
    final balanceSheet = provider.latestBalanceSheet;
    
    if (balanceSheet == null) {
      return _buildNoDataWidget('재무상태표 데이터가 없습니다.');
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 재무상태 요약 카드
          _buildSummaryCard(
            '재무상태 요약',
            [
              _buildSummaryItem('총자산', balanceSheet.total_assets),
              _buildSummaryItem('총부채', balanceSheet.total_liabilities),
              _buildSummaryItem('총자본', balanceSheet.total_equity),
            ],
          ),
          
          SizedBox(height: 16),
          
          // 자산 구성 파이차트
          _buildAssetCompositionChart(balanceSheet),
          
          SizedBox(height: 16),
          
          // 재무 건전성 지표
          _buildFinancialHealthCard(balanceSheet),
          
          SizedBox(height: 16),
          
          // 상세 재무상태표
          _buildDetailedBalanceSheet(balanceSheet),
        ],
      ),
    );
  }

  // 손익계산서 탭
  Widget _buildIncomeStatementTab(FinancialProvider provider) {
    final monthlyStatements = provider.monthlyIncomeStatements;
    
    if (monthlyStatements.isEmpty) {
      return _buildNoDataWidget('손익계산서 데이터가 없습니다.');
    }

    final latest = monthlyStatements.last;
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // 손익 요약
          _buildSummaryCard(
            '이번 달 손익',
            [
              _buildSummaryItem('매출액', latest.revenue),
              _buildSummaryItem('영업이익', latest.operating_profit),
              _buildSummaryItem('당기순이익', latest.net_profit),
            ],
          ),
          
          SizedBox(height: 16),
          
          // 수익성 지표
          _buildProfitabilityCard(latest),
          
          SizedBox(height: 16),
          
          // 월별 매출/이익 추이 차트
          _buildRevenueChart(monthlyStatements),
          
          SizedBox(height: 16),
          
          // 상세 손익계산서
          _buildDetailedIncomeStatement(latest),
        ],
      ),
    );
  }

  // 현금흐름 탭
  Widget _buildCashFlowTab(FinancialProvider provider) {
    final cashFlows = provider.cashFlowStatements;
    
    if (cashFlows.isEmpty) {
      return _buildNoDataWidget('현금흐름 데이터가 없습니다.');
    }

    final latest = cashFlows.last;
    final daysUntilShortage = provider.getDaysUntilCashShortage();
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // 현금 경고 알림
          if (daysUntilShortage > 0 && daysUntilShortage < 30)
            _buildCashWarningCard(daysUntilShortage),
          
          // 현금흐름 요약
          _buildSummaryCard(
            '이번 달 현금흐름',
            [
              _buildSummaryItem('영업활동', latest.operating_cash_flow),
              _buildSummaryItem('투자활동', latest.investing_cash_flow),
              _buildSummaryItem('재무활동', latest.financing_cash_flow),
              _buildSummaryItem('기말현금', latest.ending_cash),
            ],
          ),
          
          SizedBox(height: 16),
          
          // 현금흐름 차트
          _buildCashFlowChart(cashFlows),
          
          SizedBox(height: 16),
          
          // 상세 현금흐름표
          _buildDetailedCashFlowStatement(latest),
        ],
      ),
    );
  }

  // 재무비율 탭
  Widget _buildFinancialRatiosTab(FinancialProvider provider) {
    final ratios = provider.getFinancialRatios();
    final benchmark = provider.getIndustryBenchmark();
    
    if (ratios == null) {
      return _buildNoDataWidget('재무비율 데이터가 없습니다.');
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // 수익성 비율
          _buildRatioSection('수익성 비율', [
            _buildRatioComparison('자기자본이익률(ROE)', ratios.return_on_equity, benchmark['roe']!),
            _buildRatioComparison('총자산이익률(ROA)', ratios.return_on_assets, 8.0),
            _buildRatioComparison('매출총이익률', ratios.incomeStatement.gross_margin, benchmark['gross_margin']!),
            _buildRatioComparison('영업이익률', ratios.incomeStatement.operating_margin, benchmark['operating_margin']!),
          ]),
          
          SizedBox(height: 16),
          
          // 안전성 비율
          _buildRatioSection('안전성 비율', [
            _buildRatioComparison('유동비율', ratios.balanceSheet.current_ratio * 100, benchmark['current_ratio']! * 100),
            _buildRatioComparison('부채비율', ratios.balanceSheet.debt_ratio * 100, benchmark['debt_ratio']! * 100),
          ]),
          
          SizedBox(height: 16),
          
          // 효율성 비율
          _buildRatioSection('효율성 비율', [
            _buildRatioComparison('자산회전율', ratios.asset_turnover, 1.2),
          ]),
        ],
      ),
    );
  }

  // 세무정보 탭
  Widget _buildTaxInfoTab(FinancialProvider provider) {
    final taxInfos = provider.taxInfos;
    
    if (taxInfos.isEmpty) {
      return _buildNoDataWidget('세무정보가 없습니다.');
    }

    final latest = taxInfos.last;
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // 세무 상태 요약
          _buildSummaryCard(
            '세무 상태',
            [
              _buildSummaryItem('월 매출액', latest.monthly_sales),
              _buildSummaryItem('연 매출액(추정)', latest.annual_sales),
              _buildSummaryItem('부가가치세(월)', latest.estimated_vat / 3),
              _buildSummaryItem('소득세(연)', latest.estimated_income_tax * 4),
            ],
          ),
          
          SizedBox(height: 16),
          
          // 과세 구분
          _buildTaxStatusCard(latest),
          
          SizedBox(height: 16),
          
          // VAT 신고 일정
          _buildTaxScheduleCard(),
          
          SizedBox(height: 16),
          
          // 세무 팁
          _buildTaxTipsCard(),
        ],
      ),
    );
  }

  // 헬퍼 위젯들
  Widget _buildNoDataWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(message, style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, List<Widget> items) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, double value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '${(value / 10000).toStringAsFixed(0)}만원',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: value >= 0 ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetCompositionChart(BalanceSheet balanceSheet) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('자산 구성', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: balanceSheet.cash,
                      title: '현금',
                      color: Colors.blue,
                      radius: 60,
                    ),
                    PieChartSectionData(
                      value: balanceSheet.accounts_receivable,
                      title: '외상매출금',
                      color: Colors.green,
                      radius: 60,
                    ),
                    PieChartSectionData(
                      value: balanceSheet.inventory,
                      title: '재고',
                      color: Colors.orange,
                      radius: 60,
                    ),
                    PieChartSectionData(
                      value: balanceSheet.fixed_assets,
                      title: '고정자산',
                      color: Colors.purple,
                      radius: 60,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialHealthCard(BalanceSheet balanceSheet) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('재무 건전성', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _buildHealthIndicator('유동비율', balanceSheet.current_ratio, 1.5, '%'),
            _buildHealthIndicator('부채비율', balanceSheet.debt_ratio, 0.6, '%'),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthIndicator(String label, double value, double benchmark, String unit) {
    final isGood = value >= benchmark;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            children: [
              Text('${(value * 100).toStringAsFixed(1)}$unit'),
              SizedBox(width: 8),
              Icon(
                isGood ? Icons.trending_up : Icons.trending_down,
                color: isGood ? Colors.green : Colors.red,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedBalanceSheet(BalanceSheet balanceSheet) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('상세 재무상태표', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text('【자산】', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            _buildSummaryItem('현금/예금', balanceSheet.cash),
            _buildSummaryItem('외상매출금', balanceSheet.accounts_receivable),
            _buildSummaryItem('재고자산', balanceSheet.inventory),
            _buildSummaryItem('고정자산', balanceSheet.fixed_assets),
            Divider(),
            _buildSummaryItem('총자산', balanceSheet.total_assets),
            SizedBox(height: 8),
            Text('【부채】', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            _buildSummaryItem('외상매입금', balanceSheet.accounts_payable),
            _buildSummaryItem('단기차입금', balanceSheet.short_term_debt),
            _buildSummaryItem('장기차입금', balanceSheet.long_term_debt),
            Divider(),
            _buildSummaryItem('총부채', balanceSheet.total_liabilities),
            SizedBox(height: 8),
            Text('【자본】', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            _buildSummaryItem('자본금', balanceSheet.capital),
            _buildSummaryItem('이익잉여금', balanceSheet.retained_earnings),
            Divider(),
            _buildSummaryItem('총자본', balanceSheet.total_equity),
          ],
        ),
      ),
    );
  }

  Widget _buildProfitabilityCard(IncomeStatement statement) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('수익성 지표', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _buildPercentageItem('매출총이익률', statement.gross_margin),
            _buildPercentageItem('영업이익률', statement.operating_margin),
            _buildPercentageItem('순이익률', statement.net_margin),
          ],
        ),
      ),
    );
  }

  Widget _buildPercentageItem(String label, double percentage) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: percentage >= 0 ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(List<IncomeStatement> statements) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('매출/이익 추이', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: statements.take(6).toList().asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value.revenue / 1000000);
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                    ),
                    LineChartBarData(
                      spots: statements.take(6).toList().asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value.net_profit / 1000000);
                      }).toList(),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedIncomeStatement(IncomeStatement statement) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('상세 손익계산서', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _buildSummaryItem('매출액', statement.revenue),
            _buildSummaryItem('매출원가', -statement.cost_of_goods_sold),
            Divider(),
            _buildSummaryItem('매출총이익', statement.gross_profit),
            _buildSummaryItem('판매비와관리비', -statement.operating_expenses),
            Divider(),
            _buildSummaryItem('영업이익', statement.operating_profit),
            _buildSummaryItem('영업외수익', statement.other_income),
            _buildSummaryItem('영업외비용', -statement.other_expenses),
            Divider(),
            _buildSummaryItem('법인세차감전순이익', statement.profit_before_tax),
            _buildSummaryItem('법인세비용', -statement.tax_expense),
            Divider(),
            _buildSummaryItem('당기순이익', statement.net_profit),
          ],
        ),
      ),
    );
  }

  Widget _buildCashWarningCard(int days) {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                '현금 부족 예상: 약 ${days}일 후',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCashFlowChart(List<CashFlowStatement> cashFlows) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('현금흐름 추이', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  groupsSpace: 20,
                  barGroups: cashFlows.take(6).toList().asMap().entries.map((e) {
                    final cf = e.value;
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: cf.operating_cash_flow / 100000,
                          color: Colors.green,
                          width: 15,
                        ),
                        BarChartRodData(
                          toY: cf.investing_cash_flow / 100000,
                          color: Colors.red,
                          width: 15,
                        ),
                        BarChartRodData(
                          toY: cf.financing_cash_flow / 100000,
                          color: Colors.blue,
                          width: 15,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedCashFlowStatement(CashFlowStatement cashFlow) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('상세 현금흐름표', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _buildSummaryItem('기초현금', cashFlow.beginning_cash),
            SizedBox(height: 8),
            Text('【현금흐름】', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildSummaryItem('영업활동 현금흐름', cashFlow.operating_cash_flow),
            _buildSummaryItem('투자활동 현금흐름', cashFlow.investing_cash_flow),
            _buildSummaryItem('재무활동 현금흐름', cashFlow.financing_cash_flow),
            Divider(),
            _buildSummaryItem('총현금흐름', cashFlow.total_cash_flow),
            _buildSummaryItem('기말현금', cashFlow.ending_cash),
          ],
        ),
      ),
    );
  }

  Widget _buildRatioSection(String title, List<Widget> ratios) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            ...ratios,
          ],
        ),
      ),
    );
  }

  Widget _buildRatioComparison(String label, double actual, double benchmark) {
    final isGood = actual >= benchmark;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Row(
                children: [
                  Text('${actual.toStringAsFixed(1)}%'),
                  SizedBox(width: 8),
                  Icon(
                    isGood ? Icons.trending_up : Icons.trending_down,
                    color: isGood ? Colors.green : Colors.red,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
          LinearProgressIndicator(
            value: (actual / (benchmark * 2)).clamp(0.0, 1.0),
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              isGood ? Colors.green : Colors.red,
            ),
          ),
          Text(
            '업종평균: ${benchmark.toStringAsFixed(1)}%',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxStatusCard(TaxInfo taxInfo) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('과세 구분', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  taxInfo.is_general_taxpayer ? Icons.business : Icons.store,
                  color: taxInfo.is_general_taxpayer ? Colors.red : Colors.green,
                ),
                SizedBox(width: 8),
                Text(
                  taxInfo.is_general_taxpayer ? '일반과세자' : '간이과세자',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: taxInfo.is_general_taxpayer ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              taxInfo.is_general_taxpayer 
                ? '연 매출 4,800만원 이상으로 일반과세 적용'
                : '연 매출 4,800만원 미만으로 간이과세 적용',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxScheduleCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('세무 일정', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _buildScheduleItem('부가가치세 신고', '1/25, 4/25, 7/25, 10/25'),
            _buildScheduleItem('종합소득세 신고', '5/1 ~ 5/31'),
            _buildScheduleItem('원천세 신고', '매월 10일'),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String title, String date) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(date, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTaxTipsCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('세무 관리 팁', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _buildTipItem('📝', '영수증은 5년간 보관하세요'),
            _buildTipItem('💰', '비용처리 가능한 항목들을 확인하세요'),
            _buildTipItem('📅', '세무 신고 기한을 놓치지 마세요'),
            _buildTipItem('🤝', '복잡한 경우 세무사와 상담하세요'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String emoji, String tip) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 16)),
          SizedBox(width: 8),
          Expanded(child: Text(tip)),
        ],
      ),
    );
  }
} 