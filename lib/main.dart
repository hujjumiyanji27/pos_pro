import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screens/home_screen.dart';
import 'screens/sales_screen.dart';
import 'screens/phone_order_screen.dart';
import 'screens/customer_form_screen.dart';
import 'screens/customer_search_screen.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const EposProApp());
}

class EposProApp extends StatelessWidget {
  const EposProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EPOS PRO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/sales': (context) => const SalesScreen(),
        '/phone_order': (context) => const PhoneOrderScreen(),
        '/customer': (context) => const CustomerFormScreen(phone: ''),
        '/search-customers': (_) => const CustomerSearchScreen(),
      },
    );
  }
}
