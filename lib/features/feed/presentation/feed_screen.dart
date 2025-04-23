import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() {
  runApp(FinanceVisualizerApp());
}

class FinanceVisualizerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Финансовая визуализация',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FinanceVisualizerScreen(),
    );
  }
}

class FinanceVisualizerScreen extends StatefulWidget {
  @override
  _FinanceVisualizerScreenState createState() =>
      _FinanceVisualizerScreenState();
}

class _FinanceVisualizerScreenState extends State<FinanceVisualizerScreen> {
  double income = 0;
  double expense = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFinancialData();
  }

  Future<void> _loadFinancialData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      income = prefs.getDouble('total_income') ?? 0;
      expense = (prefs.getDouble('total_expense') ?? 0).abs();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = income + expense;
    final incomePercent = total > 0 ? (income / total) : 0.0;
    final expensePercent = total > 0 ? (expense / total) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Финансовая аналитика'),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _loadFinancialData),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Круговая диаграмма с процентами
                    CircularPercentIndicator(
                      radius: 150.0,
                      lineWidth: 25.0,
                      animation: true,
                      percent: 1.0,
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Colors.grey,
                      footer: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          'Общий баланс: ${(income - expense).toStringAsFixed(2)} ₽',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Доходы', style: TextStyle(fontSize: 14)),
                          Text(
                            '${(incomePercent * 100).toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('Расходы', style: TextStyle(fontSize: 14)),
                          Text(
                            '${(expensePercent * 100).toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      // Мультицветное отображение
                      linearGradient: LinearGradient(
                        colors: [
                          Colors.green,
                          Colors.green,
                          Colors.red,
                          Colors.red,
                        ],
                        stops: [0, incomePercent, incomePercent, 1.0],
                      ),
                    ),

                    SizedBox(height: 40),

                    // Легенда и детали
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildLegendItem('Доходы', income, Colors.green),
                        _buildLegendItem('Расходы', expense, Colors.red),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildLegendItem(String title, double value, Color color) {
    return Column(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(height: 5),
        Text(title),
        Text(
          '${value.toStringAsFixed(2)} ₽',
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
