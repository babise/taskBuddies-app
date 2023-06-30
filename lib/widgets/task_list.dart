//task_list.dart

import 'package:flutter/material.dart';
import 'package:taskbuddies/models/task.dart';
import 'package:taskbuddies/services/task_service.dart';

class TaskList extends StatefulWidget {
  final String token;
  final ValueNotifier<DateTime> selectedDate;

  TaskList({required this.token, required this.selectedDate});

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> tasks = [];
  Map<int, bool> taskValidationStatus = Map();

  @override
  void initState() {
    super.initState();
    widget.selectedDate.addListener(fetchTasks);
    fetchTasks();
  }

  @override
  void dispose() {
    widget.selectedDate.removeListener(fetchTasks);
    super.dispose();
  }

  fetchTasks() async {
    try {
      TaskService taskService = TaskService(token: widget.token);
      List<Task> fetchedTasks = await taskService.fetchTasks(widget.selectedDate.value);
      setState(() {
        tasks = fetchedTasks;
      });
    } catch (e) {
      print('Failed to load tasks: $e');
    }
  }

  void onButtonPressed(BuildContext context, Task task) async {
    bool isTaskValidated = taskValidationStatus[task.id] ?? false;

    if (isTaskValidated) {
      // Faire un appel API pour supprimer la validation.
      bool apiCallSuccessful = true; // Mettez ceci à true si l'appel API réussit, false sinon.

      // Mettre à jour l'état de validation pour cette tâche en fonction du succès de l'appel API.
      setState(() {
        taskValidationStatus[task.id] = !apiCallSuccessful;
      });
    } else {
      // Faire un appel API pour valider la tâche.
      bool apiCallSuccessful = true; // Mettez ceci à true si l'appel API réussit, false sinon.

      // Mettre à jour l'état de validation pour cette tâche en fonction du succès de l'appel API.
      setState(() {
        taskValidationStatus[task.id] = apiCallSuccessful;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        bool isTaskValidated = taskValidationStatus[tasks[index].id] ?? false;
        return ListTile(
          title: Text(tasks[index].title),
          trailing: IconButton(
            icon: Icon(
              isTaskValidated ? Icons.check_box : Icons.check_box_outline_blank,
              color: isTaskValidated ? Theme.of(context).primaryColor : Colors.grey,
            ),
            onPressed: () => onButtonPressed(context, tasks[index]),
          ),
        );
      },
    );
  }
}
