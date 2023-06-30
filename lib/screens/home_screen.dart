import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'task_form_screen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:taskbuddies/widgets/task_list.dart';

class HomeScreen extends StatefulWidget {
  final String token;

  HomeScreen({required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String username;
  ValueNotifier<DateTime> selectedDate =
      ValueNotifier<DateTime>(DateTime.now());

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  @override
  void initState() {
    super.initState();
    getUsernameFromToken();
  }

  void getUsernameFromToken() {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
    username = decodedToken['username'];
  }

  @override
  void dispose() {
    selectedDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salut, $username 👋'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskFormScreen(token: widget.token),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            icon: Icon(Icons.logout_outlined),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: TaskList(token: widget.token, selectedDate: selectedDate),
    );
  }
}
