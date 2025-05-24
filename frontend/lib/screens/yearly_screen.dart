import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class YearlyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 연간 요약
          Text(
            '올해 요약 (2024)',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          
          SizedBox(height: 16),
          
          // 요약 카드들
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  '연간 매출',
                  '${formatter.format(14500000)}원',
                  Icons.trending_up,
                  Colors.green,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  '연간 지출',
                  '${formatter.format(9200000)}원',
                  Icons.trending_down,
                  Colors.red,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  '순이익',
                  '${formatter.format(5300000)}원',
                  Icons.account_balance_wallet,
                  Colors.blue,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  '영업일수',
                  '365일',
                  Icons.calendar_today,
                  Colors.orange,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 24),
          
          // 월별 매출 차트
          Text(
            '월별 매출 현황',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          
          SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                height: 250,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 1500000,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const months = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
                            return Text(
                              months[value.toInt()],
                              style: TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 1000000, color: Colors.blue[700])]),
                      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 1100000, color: Colors.blue[700])]),
                      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 1200000, color: Colors.blue[700])]),
                      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 1250000, color: Colors.blue[700])]),
                      BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 1350000, color: Colors.blue[700])]),
                      BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 1400000, color: Colors.blue[700])]),
                      BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 1450000, color: Colors.blue[700])]),
                      BarChartGroupData(x: 7, barRods: [BarChartRodData(toY: 1300000, color: Colors.blue[700])]),
                      BarChartGroupData(x: 8, barRods: [BarChartRodData(toY: 1200000, color: Colors.blue[700])]),
                      BarChartGroupData(x: 9, barRods: [BarChartRodData(toY: 1250000, color: Colors.blue[700])]),
                      BarChartGroupData(x: 10, barRods: [BarChartRodData(toY: 1150000, color: Colors.blue[700])]),
                      BarChartGroupData(x: 11, barRods: [BarChartRodData(toY: 1200000, color: Colors.blue[700])]),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(height: 24),
          
          // 계절별 분석
          Text(
            '계절별 매출 분석',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          
          SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: 25,
                        title: '봄\n25%',
                        color: Colors.green[700],
                        radius: 60,
                        titleStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        value: 30,
                        title: '여름\n30%',
                        color: Colors.orange[700],
                        radius: 60,
                        titleStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        value: 28,
                        title: '가을\n28%',
                        color: Colors.brown[700],
                        radius: 60,
                        titleStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        value: 17,
                        title: '겨울\n17%',
                        color: Colors.blue[700],
                        radius: 60,
                        titleStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(height: 24),
          
          // 연간 성과 리포트
          Text(
            '연간 성과 리포트',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          
          SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPerformanceItem(
                    '매출 성장률',
                    '+18.2%',
                    '작년 대비 매출이 크게 증가했습니다',
                    Icons.trending_up,
                    Colors.green,
                  ),
                  Divider(),
                  _buildPerformanceItem(
                    '최고 매출월',
                    '7월',
                    '1,450,000원으로 최고 매출을 기록했습니다',
                    Icons.star,
                    Colors.orange,
                  ),
                  Divider(),
                  _buildPerformanceItem(
                    '총 고객 수',
                    '2,456명',
                    '올해 서비스를 이용한 총 고객 수입니다',
                    Icons.people,
                    Colors.blue,
                  ),
                  Divider(),
                  _buildPerformanceItem(
                    '평균 일 매출',
                    '39,726원',
                    '하루 평균 매출 금액입니다',
                    Icons.account_balance_wallet,
                    Colors.purple,
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 24),
          
          // 내년 목표 설정
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.flag, color: Colors.blue[700]),
                      SizedBox(width: 8),
                      Text(
                        '2025년 목표',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    '• 연간 매출 20% 증가 (17,400,000원)',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• 신규 고객 1,000명 확보',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• 디지털 주문 시스템 도입',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceItem(String title, String value, String description, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 