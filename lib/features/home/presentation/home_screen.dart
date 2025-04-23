import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(FinanceApp());
}

class FinanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Финансовый отчет',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FinanceSummaryScreen(),
    );
  }
}

class FinanceSummaryScreen extends StatefulWidget {
  @override
  _FinanceSummaryScreenState createState() => _FinanceSummaryScreenState();
}

class _FinanceSummaryScreenState extends State<FinanceSummaryScreen> {
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

    setState(() {});
  }

  Widget _buildFinanceSection(
    String title,
    Map<String, double> data,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        if (data.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Нет данных', style: TextStyle(color: Colors.grey)),
          )
        else
          ...data.entries
              .map(
                (entry) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key),
                      Text(
                        '${entry.value.toStringAsFixed(2)} руб.',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        Divider(),
      ],
    );
  }

  Widget _buildTotalSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Общий доход:'),
              Text(
                '${totalIncome.toStringAsFixed(2)} руб.',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Общий расход:'),
              Text(
                '${totalExpense.toStringAsFixed(2)} руб.',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ИТОГО:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '${balance.toStringAsFixed(2)} руб.',
                style: TextStyle(
                  color: balance >= 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Финансовый отчет'),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _loadFinanceData),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildFinanceSection('ДОХОДЫ', incomes, Colors.green),
            _buildFinanceSection('РАСХОДЫ', expenses, Colors.red),
            _buildTotalSection(),
          ],
        ),
      ),
    );
  }
}
