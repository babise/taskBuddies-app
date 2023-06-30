import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/task_form_screen.dart';
import 'theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Buddies',
      theme: AppTheme.customTheme,
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(token: ''),
        '/taskForm': (context) => TaskFormScreen(token: ''),
      },
      home: FutureBuilder(
        future: _getToken(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data != null) {
              return HomeScreen(token: snapshot.data!);
            } else {
              return LoginScreen();
            }
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Future<String?> _getToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'jwtToken');
  }
}
