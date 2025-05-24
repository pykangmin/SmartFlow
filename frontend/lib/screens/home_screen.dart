import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/receipt_provider.dart';
import '../providers/financial_provider.dart';
import '../screens/daily_screen.dart';
import '../screens/weekly_screen.dart';
import '../screens/monthly_screen.dart';
import '../screens/yearly_screen.dart';
import '../screens/financial_screen.dart';
import '../widgets/camera_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    DailyScreen(),
    WeeklyScreen(),
    MonthlyScreen(),
    YearlyScreen(),
    FinancialScreen(),
  ];

  final List<String> _titles = [
    '일간',
    '주간',
    '월간',
    '연간',
    '재무',
  ];

  @override
  void initState() {
    super.initState();
    // 샘플 데이터 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReceiptProvider>(context, listen: false)
          .initializeSampleData();
      Provider.of<FinancialProvider>(context, listen: false)
          .initializeSampleFinancialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Flow - ${_titles[_selectedIndex]}'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 탭 버튼들
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
            child: Row(
              children: List.generate(5, (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: _selectedIndex == index
                            ? Colors.white.withOpacity(0.2)
                            : Colors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedIndex == index
                                ? Colors.white
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        _titles[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: _selectedIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          
          // 메인 컨텐츠
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
      
      // 플로팅 액션 버튼 (카메라)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCameraBottomSheet(context);
        },
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        icon: Icon(Icons.camera_alt),
        label: Text('영수증 촬영'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showCameraBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  '영수증 업로드',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: CameraWidget(),
              ),
            ],
          ),
        );
      },
    );
  }
} 