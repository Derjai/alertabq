import 'package:alertabq/app_theme.dart/app_theme.dart';
import 'package:alertabq/auth/landing_page.dart';
import 'package:alertabq/auth/login.dart';
import 'package:alertabq/auth/register.dart';
import 'package:alertabq/views/home_screen.dart';
import 'package:alertabq/views/my_reports.dart';
import 'package:alertabq/views/profile_screen.dart';
import 'package:alertabq/views/reports.dart';
import 'package:alertabq/views/submit_report.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        initialRoute: '/',
        routes: {
          '/': (context) => const LandingPage(),
          '/Login': (context) => const Login(),
          '/Register': (context) => const Register(),
          '/Home': (context) => const HomeScreen(),
          '/History': (context) => const MyReports(),
          '/Profile': (context) => const ProfileScreen(),
          '/Reports': (context) => const Reports(),
          '/Submit': (context) => const SubmitReport()
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
