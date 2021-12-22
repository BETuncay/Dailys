import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dailys.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key, required this.historyBox, required this.tasksBox})
      : super(key: key);

  final Box<DailyHistory> historyBox;
  final Box<DailyData> tasksBox;
  final _biggerFont = const TextStyle(fontSize: 18);
  final Set<String> dotsMenu = const {'New Daily', 'Clear Dailys'};

  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final Set<DailyData> _selectedDailys = {};

  bool get someDailySelected => _selectedDailys.isNotEmpty;

  void _clearDailySelection() {
    setState(() {
      _selectedDailys.clear();
    });
  }

  void _editSelectedDailys() {
    _editDailyInputDialog(context, _selectedDailys.first);
    _clearDailySelection();
  }

  _deleteSelectedDailys() {
    for (var i = 0; i < _selectedDailys.length; i++) {
      widget.tasksBox.delete(_selectedDailys.elementAt(i).id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dailys'),
        titleSpacing: 20,
        actions: <Widget>[
          someDailySelected
              ? IconButton(
                  onPressed: () {
                    _clearDailySelection();
                  },
                  icon: const Icon(Icons.clear))
              : Container(),
          _selectedDailys.length == 1
              ? IconButton(
                  onPressed: () {
                    _editSelectedDailys();
                  },
                  icon: const Icon(Icons.edit))
              : Container(),
          someDailySelected
              ? IconButton(
                  onPressed: () {
                    _deleteSelectedDailys();
                  },
                  icon: const Icon(Icons.delete))
              : Container(),
          PopupMenuButton<String>(
            onSelected: handleAppbarClick,
            itemBuilder: (BuildContext context) {
              return widget.dotsMenu.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _buildDailys(),
    );
  }

  void handleAppbarClick(String value) {
    switch (value) {
      case 'New Daily':
        _addDailyInputDialog(context);
        break;
      case 'Clear Dailys':
        widget.tasksBox.clear();
        break;
    }
  }

  Widget _buildDailys() {
    return ValueListenableBuilder(
        valueListenable: (widget.tasksBox).listenable(),
        builder: (context, Box<DailyData> box, _) {
          return ListView.builder(
              itemCount: box.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (BuildContext _context, int i) {
                return _buildRow(widget.tasksBox.getAt(i));
              });
        });
  }

  Widget _buildRow(DailyData? daily) {
    if (daily == null) {
      return const Divider();
    }
    bool dailyCompleted = dailyCompletedToday(daily);
    bool isSelected = _selectedDailys.contains(daily);
    return ListTile(
      title: Text(
        daily.task,
        style: widget._biggerFont,
      ),
      trailing: Icon(
        dailyCompleted ? Icons.check_box : Icons.check_box_outline_blank,
        color: dailyCompleted ? Colors.blue : null,
        semanticLabel: dailyCompleted ? 'Done!' : 'Not Done!',
      ),
      onTap: () {
        if (someDailySelected) {
          longTapOnDaily(daily);
        } else {
          tapOnDaily(daily);
        }
      },
      onLongPress: () {
        longTapOnDaily(daily);
      },
      tileColor: isSelected ? const Color(0x200000DA) : null,
    );
  }

  DailyHistory getDailyHistory(DateTime inputDate) {
    DateTime date = DateTime(inputDate.year, inputDate.month, inputDate.day);
    String dateString = date.toString();
    var dailyHistory = widget.historyBox.get(dateString);
    if (dailyHistory == null) {
      dailyHistory = DailyHistory(date, HiveList(widget.tasksBox));
      widget.historyBox.put(dateString, dailyHistory);
    }
    return dailyHistory;
  }

  bool dailyCompletedToday(DailyData daily) {
    DailyHistory dailyHistory = getDailyHistory(DateTime.now());
    bool contains = dailyHistory.dailys.contains(daily);
    return contains;
  }

  void tapOnDaily(DailyData daily) {
    setState(() {
      DailyHistory dailyHistory = getDailyHistory(DateTime.now());
      bool contains = dailyHistory.dailys.contains(daily);

      if (contains) {
        dailyHistory.dailys.remove(daily);
      } else {
        dailyHistory.dailys.add(daily);
      }
      dailyHistory.save();
    });
  }

  void longTapOnDaily(DailyData daily) {
    setState(() {
      if (_selectedDailys.contains(daily)) {
        _selectedDailys.remove(daily);
      } else {
        _selectedDailys.add(daily);
      }

      //_editDailyInputDialog(context, daily);
    });
  }

  Future<void> _addDailyInputDialog(BuildContext context) async {
    String dailyTask = '';
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add new daily'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  dailyTask = value;
                });
              },
              controller: TextEditingController(),
              decoration: const InputDecoration(hintText: "Enter your task!"),
            ),
            actions: <Widget>[
              const SizedBox(height: 30),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  checkDailyInput(dailyTask, context);
                  _addDaily(dailyTask);
                },
                child: const Text('Add'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  // almost same function as _addDailyInputDialog
  // ToDo abstract functionality into a single function or a TextDialog class
  Future<void> _editDailyInputDialog(
      BuildContext context, DailyData daily) async {
    debugPrint("jello");
    String dailyTask = '';
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit daily'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  dailyTask = value;
                });
              },
              controller: TextEditingController(),
              decoration: InputDecoration(hintText: daily.task),
            ),
            actions: <Widget>[
              const SizedBox(height: 30),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  checkDailyInput(dailyTask, context);
                  _editDaily(daily, dailyTask);
                },
                child: const Text('Edit'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  void pushContext(BuildContext context, Widget widget) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      return widget;
    }));
  }

  checkDailyInput(String dailyTask, BuildContext context) {
    String removeWhiteSpaces = dailyTask.replaceAll(' ', '');
    if (removeWhiteSpaces == '') {
      return showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
                backgroundColor: Colors.red,
                content: Text('Enter a valid input or else!'));
          });
    }
  }

  _addDaily(String dailyTask) {
    String removeWhiteSpaces = dailyTask.replaceAll(' ', '');
    if (removeWhiteSpaces != '') {
      setState(() {
        DailyData temp = DailyData(widget.tasksBox.length, dailyTask);
        widget.tasksBox.add(temp);
        Navigator.pop(context);
      });
    }
  }

  _editDaily(DailyData daily, String task) {
    String removeWhiteSpaces = task.replaceAll(' ', '');
    if (removeWhiteSpaces != '') {
      setState(() {
        daily.task = task;
        daily.save();
        Navigator.pop(context);
      });
    }
  }
}
