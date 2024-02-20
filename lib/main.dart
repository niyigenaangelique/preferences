import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ConnectivityResult _connectionStatus;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _connectionStatus = result;
    });
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _connectionStatus = result;
    });
    Fluttertoast.showToast(
        msg: _connectionStatus == ConnectivityResult.none
            ? "No Internet Connection"
            : "Connected to Internet");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internet Connectivity Demo'),
      ),
      body: Center(
        child: Text(
          'Connection Status: ${_connectionStatus.toString()}',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class AuthService {
  Future<bool> signUp(String email, String password) async {
    // Implementation for SignUp
    // Replace this with your actual SignUp logic
    await Future.delayed(Duration(seconds: 2));
    return true; // Assume signup was successful
  }

  Future<bool> signIn(String email, String password) async {
    // Implementation for SignIn
    // Replace this with your actual SignIn logic
    await Future.delayed(Duration(seconds: 2));
    return true; // Assume signin was successful
  }
}

class AuthScreen extends StatelessWidget {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                bool result =
                    await authService.signUp('example@example.com', 'password');
                if (result) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('SignUp Successful')));
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('SignUp Failed')));
                }
              },
              child: Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: () async {
                bool result =
                    await authService.signIn('example@example.com', 'password');
                if (result) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('SignIn Successful')));
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('SignIn Failed')));
                }
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeScreen extends StatefulWidget {
  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  bool _isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    });
  }

  Future<void> _toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkTheme = !_isDarkTheme;
      prefs.setBool('isDarkTheme', _isDarkTheme);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Demo'),
      ),
      body: Center(
        child: Switch(
          value: _isDarkTheme,
          onChanged: (value) {
            _toggleTheme();
          },
        ),
      ),
    );
  }
}
