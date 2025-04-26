import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/feed/domain/feed_entry.dart';
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
  Map<String, double> incomes = {};
  Map<String, double> expenses = {};
  double totalIncome = 0;
  double totalExpense = 0;
  double balance = 0;

  @override
  void initState() {
    super.initState();
    _loadFinanceData();
  }

  Future<void> _loadFinanceData() async {
    final prefs = await SharedPreferences.getInstance();

    // Загрузка доходов
    incomes = {};
    totalIncome = 0;
    final allKeys = prefs.getKeys();
    for (var key in allKeys) {
      if (key.startsWith('income_')) {
        final category = key.replaceFirst('income_', '');
        final value = prefs.getDouble(key) ?? 0;
        if (value > 0) {
          incomes[category] = value;
          totalIncome += value;
        }
      }
    }

    // Загрузка расходов
    expenses = {};
    totalExpense = 0;
    for (var key in allKeys) {
      if (key.startsWith('expense_')) {
        final category = key.replaceFirst('expense_', '');
        final value = prefs.getDouble(key) ?? 0;
        if (value < 0) {
          expenses[category] = value;
          totalExpense += value;
        }
      }
    }

    // Расчет общего баланса
    balance = totalIncome + totalExpense;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = totalIncome + -1*totalExpense;
    final incomePercent = total > 0 ? (totalIncome / total) : 0.0;
    print(incomePercent);
    final expensePercent = total > 0 ? (totalExpense / total) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Финансовая аналитика'),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _loadFinanceData),
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
