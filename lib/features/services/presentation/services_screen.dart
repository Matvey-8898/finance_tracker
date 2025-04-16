import 'package:flutter/material.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int _selectedIndex = 0;
  double salaryAmount = 0.0;

  void _showSalaryDialog() {
    TextEditingController salaryController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Введите зарплату'),
          content: TextField(
            controller: salaryController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Сумма больше 0'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Сохранить'),
              onPressed: () {
                double value = double.tryParse(salaryController.text) ?? 0;
                if (value > 0) {
                  setState(() {
                    salaryAmount = value;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Зарплата $value сохранена')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Введите число больше 0')),
                  );
                }
              },
            ),
          ],
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
                        _selectedIndex == 0 ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: Text('ДОХОДЫ'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _selectedIndex == 1 ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: Text('РАСХОДЫ'),
                ),
              ),
            ],
          ),
          Expanded(
            child:
                _selectedIndex == 0
                    ? Column(
                      children: [
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _showSalaryDialog,
                          child: Text('ЗАРПЛАТА'),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Текущая зарплата: $salaryAmount',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    )
                    : Center(
                      child: Text('РАСХОДЫ', style: TextStyle(fontSize: 24)),
                    ),
          ),
        ],
      ),
    );
  }
}
