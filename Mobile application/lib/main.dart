import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PageNav.dart';
import 'Login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          // While the future is being resolved, show a loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // When the future resolves, show the appropriate page
          if (snapshot.hasData && snapshot.data == true) {
            return PageNav(activePage: 0);
          } else {
            return Login();
          }
        },
      ),
    );
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return token != null;
  }
}
