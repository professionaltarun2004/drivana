import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/transactions_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(DrivanaApp());
}

class DrivanaApp extends StatefulWidget {
  @override
  _DrivanaAppState createState() => _DrivanaAppState();
}

class _DrivanaAppState extends State<DrivanaApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ProfileScreen(),
    OrdersScreen(),
    TransactionsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drivana',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Orders'),
            BottomNavigationBarItem(
              icon: Icon(Icons.payment),
              label: 'Transactions',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber.shade300,
          unselectedItemColor: Colors.grey.shade600,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
