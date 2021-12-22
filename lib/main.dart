import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dailys.dart';
import 'dailys_tab.dart';
import 'calender_tab.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<DailyData>(DailyDataAdapter());
  Hive.registerAdapter<DailyHistory>(DailyHistoryAdapter());
  await Hive.openBox<DailyData>(dailyBoxName);
  await Hive.openBox<DailyHistory>(dailyHistoryBoxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: "Daily's", home: MainTabsBottom()); //Tasks());
  }
}

class MainTabsBottom extends StatefulWidget {
  const MainTabsBottom({Key? key}) : super(key: key);

  @override
  State<MainTabsBottom> createState() => _MainTabsBottomState();
}

class _MainTabsBottomState extends State<MainTabsBottom> {
  int _selectedIndex = 0;
  late Box<DailyData> _tasksBox;
  late Box<DailyHistory> _historyBox;
  static late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _tasksBox = Hive.box(dailyBoxName);
    _historyBox = Hive.box(dailyHistoryBoxName);
    _widgetOptions = <Widget>[
      Tasks(historyBox: _historyBox, tasksBox: _tasksBox),
      TableComplexExample(historyBox: _historyBox, tasksBox: _tasksBox),
      const Text('Drip'),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Drip',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // 800
        onTap: _onItemTapped,
      ),
    );
  }
}
