import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taskbuddies/models/task.dart';
import 'package:taskbuddies/config.dart';

class TaskService {
  final String token;

  TaskService({required this.token});

  Future<List<Task>> fetchTasks(DateTime selectedDate) async {
    final response = await http.get(
      Uri.parse('$apiBaseUrl/task/date?date=${selectedDate.toIso8601String()}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> addTask({
    required String title,
    required List<Map<String, dynamic>> recurrences,
  }) async {
    final url = '$apiBaseUrl/task';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final requestData = {
      'title': title,
      'recurrences': recurrences,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(requestData),
    );
    print('Request data: $requestData');


    if (response.statusCode < 200 || response.statusCode >= 300) {
      // Une erreur s'est produite lors de l'ajout de la tâche
      throw Exception('Failed to add task');
    }
  }
}
