import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/receipt_provider.dart';
import '../models/receipt.dart';

class DailyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReceiptProvider>(
      builder: (context, provider, child) {
        final todayReceipts = provider.getTodayReceipts();
        final formatter = NumberFormat('#,###');
        
        return RefreshIndicator(
          onRefresh: () async {
            await provider.loadDailyAnalysis(DateTime.now());
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 날짜 표시
                Text(
                  DateFormat('yyyy년 MM월 dd일 (EEEE)', 'ko').format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                
                SizedBox(height: 20),
                
                // 요약 카드들
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        '총 매출액',
                        '${formatter.format(provider.dailyRevenue)}원',
                        Icons.trending_up,
                        Colors.green,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryCard(
                        '총 지출액',
                        '${formatter.format(provider.dailyExpense)}원',
                        Icons.trending_down,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
                _buildSummaryCard(
                  '영수증 개수',
                  '${provider.dailyReceiptCount}개',
                  Icons.receipt_long,
                  Colors.blue,
                ),
                
                SizedBox(height: 24),
                
                // 오늘의 영수증 리스트
                Text(
                  '오늘의 영수증 내역',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                
                SizedBox(height: 12),
                
                if (todayReceipts.isEmpty)
                  _buildEmptyState()
                else
                  Column(
                    children: todayReceipts.map((receipt) {
                      return _buildReceiptCard(receipt, formatter);
                    }).toList(),
                  ),
                
                SizedBox(height: 80), // 플로팅 버튼 공간
              ],
            ),
          ),
        );
      },
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

  Widget _buildReceiptCard(Receipt receipt, NumberFormat formatter) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('HH:mm').format(receipt.receiptDate),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${formatter.format(receipt.totalAmount)}원',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
            
            if (receipt.items.isNotEmpty) ...[
              SizedBox(height: 12),
              ...receipt.items.map((item) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.name} x ${item.quantity}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${formatter.format(item.totalPrice)}원',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              '오늘 등록된 영수증이 없습니다',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              '아래 버튼을 눌러 영수증을 등록해보세요',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 