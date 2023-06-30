import 'package:flutter/material.dart';
import 'package:taskbuddies/services/task_service.dart';

class TaskFormScreen extends StatefulWidget {
  final String token;

  const TaskFormScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final TextEditingController _titleController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  String? _recurrenceType;
  List<String> _recurrenceOptions = ['Unique', 'Semaine', 'Mois', 'Intervalle'];
  List<bool> _selectedWeekDays = List.filled(7, false);
  int? _selectedDayOfMonth;
  int? _selectedInterval;


  Future<void> _addTask() async {
    try {
      final List<Map<String, dynamic>> recurrences = [];

      if (_recurrenceType == 'Unique') {
        final Map<String, dynamic> recurrenceData = {
          'start_date': _startDate?.toIso8601String(),
          'end_date': null,
          'day_of_week': null,
          'day_of_month': null,
          'recurrence_interval': null
        };
        recurrences.add(recurrenceData);
      } else if (_recurrenceType == 'Semaine') {
        for (int i = 0; i < _selectedWeekDays.length; i++) {
          if (_selectedWeekDays[i]) {
            final Map<String, dynamic> recurrenceData = {
              'start_date': _startDate?.toIso8601String(),
              'end_date': _endDate?.toIso8601String(),
              'day_of_week': i + 1, // 1 for Monday, 2 for Tuesday, ...
              'day_of_month': null,
              'recurrence_interval': null
            };
            recurrences.add(recurrenceData);
          }
        }
      } else if (_recurrenceType == 'Mois') {
        final Map<String, dynamic> recurrenceData = {
          'start_date': _startDate?.toIso8601String(),
          'end_date': _endDate?.toIso8601String(),
          'day_of_week': null,
          'day_of_month': _selectedDayOfMonth,
          'recurrence_interval': null
        };
        recurrences.add(recurrenceData);
      } else if (_recurrenceType == 'Intervalle') {
        final Map<String, dynamic> recurrenceData = {
          'start_date': _startDate?.toIso8601String(),
          'end_date': _endDate?.toIso8601String(),
          'day_of_week': null,
          'day_of_month': null,
          'recurrence_interval': _selectedInterval
        };
        recurrences.add(recurrenceData);
      }

      TaskService taskService = TaskService(token: widget.token);
      await taskService.addTask(title: _titleController.text, recurrences: recurrences);

      // Task has been added successfully
      Navigator.pop(context);
    } catch (e) {
      // Error occurred while adding the task
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Failed to add task: $e'),
          );
        },
      );
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une tâche'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Titre',
                hintText: 'Entrez le titre de la tâche',
              ),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _recurrenceType,
              hint: Text("Sélectionnez le type de récurrence"),
              onChanged: (String? newValue) {
                setState(() {
                  _recurrenceType = newValue;
                });
              },
              items: _recurrenceOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            if (_recurrenceType == 'Semaine') ...[
              ToggleButtons(
                children: [
                  Text("L"),
                  Text("M"),
                  Text("M"),
                  Text("J"),
                  Text("V"),
                  Text("S"),
                  Text("D"),
                ],
                isSelected: _selectedWeekDays,
                onPressed: (int index) {
                  setState(() {
                    _selectedWeekDays[index] = !_selectedWeekDays[index];
                  });
                },
              )
            ] else if (_recurrenceType == 'Mois') ...[
              DropdownButton<int>(
                value: _selectedDayOfMonth,
                hint: Text("Sélectionnez un jour du mois "),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedDayOfMonth = newValue;
                  });
                },
                items: List.generate(31, (index) => index + 1)
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
            ] else if (_recurrenceType == 'Intervalle') ...[
              DropdownButton<int>(
                value: _selectedInterval,
                hint: Text("Sélectionnez un intervalle"),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedInterval = newValue;
                  });
                },
                items: List.generate(30, (index) => index + 1)
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
            ],
            if (_recurrenceType != 'Unique') ...[
              SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _startDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null && selectedDate != _startDate) {
                    setState(() {
                      _startDate = selectedDate;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date de début',
                  ),
                  child: Text(_startDate == null
                      ? 'Sélectionnez une date'
                      : _startDate!.toLocal().toString().split(' ')[0]),
                ),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _endDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null && selectedDate != _endDate) {
                    setState(() {
                      _endDate = selectedDate;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date de fin',
                  ),
                  child: Text(_endDate == null
                      ? 'Sélectionnez une date'
                      : _endDate!.toLocal().toString().split(' ')[0]),
                ),
              ),
            ],
            ElevatedButton(
              onPressed: () {
                _addTask();

              },
              child: Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
}
