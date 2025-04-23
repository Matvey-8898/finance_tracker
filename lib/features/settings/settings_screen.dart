import 'package:flutter/material.dart'
    show
        AppBar,
        BuildContext,
        Center,
        Color,
        Colors,
        Column,
        CrossAxisAlignment,
        EdgeInsets,
        ElevatedButton,
        GlobalKey,
        MainAxisAlignment,
        MaterialApp,
        Navigator,
        NavigatorState,
        Padding,
        Row,
        Scaffold,
        SizedBox,
        State,
        StatefulWidget,
        StatelessWidget,
        Text,
        TextStyle,
        ThemeData,
        ValueListenableBuilder,
        ValueNotifier,
        Widget,
        Wrap,
        runApp;

void main() {
  runApp(MyApp());
}

// Глобальный ключ для доступа к состоянию из любого места
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  // Глобальный цвет, который будет использоваться во всех окнах
  static ValueNotifier<Color> appColor = ValueNotifier<Color>(Colors.white);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: appColor,
      builder: (context, color, child) {
        return MaterialApp(
          title: 'Многооконное приложение',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: color,
          ),
          navigatorKey: navigatorKey,
          initialRoute: '/',
          routes: {
            '/': (context) => FirstWindow(),
            '/second': (context) => SecondWindow(),
            '/third': (context) => ThirdWindow(),
            '/fourth': (context) => FourthWindow(),
          },
        );
      },
    );
  }
}

class FirstWindow extends StatefulWidget {
  @override
  _FirstWindowState createState() => _FirstWindowState();
}

class _FirstWindowState extends State<FirstWindow> {
  bool _showColorButtons = false;

  final Map<String, Color> _colorOptions = {
    'СИНИЙ': Colors.blue,
    'ЧЕРНЫЙ': Colors.black,
    'РОЗОВЫЙ': Colors.pink,
    'ОРАНЖЕВЫЙ': Colors.orange,
    'ЖЕЛТЫЙ': Colors.yellow,
    'ЗЕЛЕНЫЙ': Colors.green,
  };

  void _changeAllWindowsColor(Color color) {
    MyApp.appColor.value = color;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Окно 1 - Настройки цвета')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showColorButtons = !_showColorButtons;
                });
              },
              child: Text('ВЫБЕРИ ЦВЕТ ЭКРАНА'),
            ),

            if (_showColorButtons) ...[
              SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    _colorOptions.entries.map((entry) {
                      return ElevatedButton(
                        onPressed: () => _changeAllWindowsColor(entry.value),
                        child: Text(
                          entry.key,
                          style: TextStyle(
                            color:
                                entry.value.computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: entry.value,
                        ),
                      );
                    }).toList(),
              ),
            ],

            SizedBox(height: 40),
            Text('Другие окна:'),
            Row(
              children: [
                _buildWindowButton(context, 'Окно 2', '/second'),
                _buildWindowButton(context, 'Окно 3', '/third'),
                _buildWindowButton(context, 'Окно 4', '/fourth'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWindowButton(BuildContext context, String text, String route) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, route),
        child: Text(text),
      ),
    );
  }
}

// Остальные окна имеют одинаковую структуру
class SecondWindow extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Окно 2')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Это второе окно'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}

class ThirdWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Окно 3')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Это третье окно'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}

class FourthWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Окно 4')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Это четвертое окно'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}
