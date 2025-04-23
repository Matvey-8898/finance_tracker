import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(FinanceApp());
}

class FinanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Учет финансов',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FinanceTracker(),
    );
  }
}

class FinanceTracker extends StatefulWidget {
  @override
  _FinanceTrackerState createState() => _FinanceTrackerState();
}

class _FinanceTrackerState extends State<FinanceTracker> {
  int _currentTabIndex = 0;
  final Map<String, double> _incomes = {
    'Зарплата': 0,
    'Подарки': 0,
    'Инвестиции': 0,
    'Другое': 0,
  };
  final Map<String, double> _expenses = {
    'Шоппинг': 0,
    'Еда': 0,
    'Техника': 0,
    'Путешествия': 0,
    'Табак': 0,
    'Ремонт': 0,
    'Мебель': 0,
    'Жилье': 0,
    'Подарки': 0,
    'Благотворительность': 0,
    'Перевод': 0,
    'Здоровье': 0,
    'Одежда': 0,
    'Другое': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Загрузка доходов
    for (var key in _incomes.keys) {
      final value = prefs.getDouble('income_$key');
      if (value != null) {
        _incomes[key] = value;
      }
    }

    // Загрузка расходов
    for (var key in _expenses.keys) {
      final value = prefs.getDouble('expense_$key');
      if (value != null) {
        _expenses[key] = value;
      }
    }

    setState(() {});
  }

  Future<void> _saveAmount(String type, String category, double amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('${type}_$category', amount);
  }

  void _showEditDialog(String category, bool isIncome) {
    final controller = TextEditingController();
    final currentAmount = isIncome ? _incomes[category] : _expenses[category];
    if (currentAmount != 0) {
      controller.text = currentAmount!.abs().toString();
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Редактировать $category'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Введите сумму',
                suffixText: 'руб.',
              ),
            ),
            actions: [
              TextButton(
                child: Text('Отмена'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('Сохранить'),
                onPressed: () {
                  final input = controller.text.trim();
                  final amount = double.tryParse(input) ?? 0;
                  final validatedAmount = isIncome ? amount : -amount;

                  if (validatedAmount != 0) {
                    setState(() {
                      if (isIncome) {
                        _incomes[category] = validatedAmount;
                      } else {
                        _expenses[category] = validatedAmount;
                      }
                    });
                    _saveAmount(
                      isIncome ? 'income' : 'expense',
                      category,
                      validatedAmount,
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Введите корректную сумму'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
    );
  }

  Widget _buildCategoryList(bool isIncome) {
    final categories = isIncome ? _incomes : _expenses;

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories.keys.elementAt(index);
        final amount = categories[category]!;

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(category),
            subtitle: Text(
              '${amount.toStringAsFixed(2)} руб.',
              style: TextStyle(
                color: isIncome ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(Icons.edit),
            onTap: () => _showEditDialog(category, isIncome),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Учет финансов')),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _currentTabIndex == 0 ? Colors.green : Colors.grey,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => setState(() => _currentTabIndex = 0),
                  child: Text('ДОХОДЫ'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _currentTabIndex == 1 ? Colors.red : Colors.grey,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => setState(() => _currentTabIndex = 1),
                  child: Text('РАСХОДЫ'),
                ),
              ),
            ],
          ),
          Expanded(
            child:
                _currentTabIndex == 0
                    ? _buildCategoryList(true)
                    : _buildCategoryList(false),
          ),
        ],
      ),
    );
  }
}
