import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class WeeklyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 주간 요약
          Text(
            '이번 주 요약',
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
                  '주간 매출',
                  '${formatter.format(280000)}원',
                  Icons.trending_up,
                  Colors.green,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  '주간 지출',
                  '${formatter.format(150000)}원',
                  Icons.trending_down,
                  Colors.red,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 24),
          
          // 일별 매출 차트
          Text(
            '일별 매출 현황',
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
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 60000,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = ['월', '화', '수', '목', '금', '토', '일'];
                            return Text(
                              days[value.toInt()],
                              style: TextStyle(fontSize: 12),
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
                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 40000, color: Colors.blue[700])]),
                      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 35000, color: Colors.blue[700])]),
                      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 50000, color: Colors.blue[700])]),
                      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 45000, color: Colors.blue[700])]),
                      BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 38000, color: Colors.blue[700])]),
                      BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 42000, color: Colors.blue[700])]),
                      BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 30000, color: Colors.blue[700])]),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(height: 24),
          
          // 주요 인사이트
          Text(
            '주요 인사이트',
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
                  _buildInsightItem(
                    Icons.trending_up,
                    '매출 증가',
                    '지난주 대비 15% 증가했습니다',
                    Colors.green,
                  ),
                  Divider(),
                  _buildInsightItem(
                    Icons.schedule,
                    '피크 시간',
                    '오후 2-4시에 가장 많은 매출이 발생합니다',
                    Colors.orange,
                  ),
                  Divider(),
                  _buildInsightItem(
                    Icons.star,
                    '인기 메뉴',
                    '아메리카노가 가장 많이 팔렸습니다',
                    Colors.blue,
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
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(IconData icon, String title, String description, Color color) {
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
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
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