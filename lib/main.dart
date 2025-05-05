// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/login_screen.dart'; // Ensure this file exists

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const DrivanaApp());
}

class DrivanaApp extends StatefulWidget {
  const DrivanaApp({super.key});

  @override
  _DrivanaAppState createState() => _DrivanaAppState();
}

class _DrivanaAppState extends State<DrivanaApp> {
  Locale _locale = const Locale('en'); // Default language

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        if (!snapshot.hasData) {
          // User is not authenticated, redirect to login screen
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Drivana',
            locale: _locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('es'), Locale('hi')],
            theme: ThemeData(
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.grey[100],
              textTheme: const TextTheme(
                headlineLarge: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
                bodyMedium: TextStyle(fontFamily: 'Poppins'),
              ).apply(bodyColor: Colors.black, displayColor: Colors.black),
              fontFamily: 'Poppins',
            ),
            home: const LoginScreen(),
          );
        }
        // User is authenticated, show the main app
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Drivana',
          locale: _locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('es'), Locale('hi')],
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.grey[100],
            textTheme: const TextTheme(
              headlineLarge: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
              bodyMedium: TextStyle(fontFamily: 'Poppins'),
            ).apply(bodyColor: Colors.black, displayColor: Colors.black),
            fontFamily: 'Poppins',
          ),
          home: MainScreen(onLanguageChange: _changeLanguage),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final Function(Locale) onLanguageChange;

  const MainScreen({super.key, required this.onLanguageChange});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProfileScreen(),
    const OrdersScreen(),
    const TransactionsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final localizations = AppLocalizations.of(context);
        if (localizations == null) {
          return const AlertDialog(
            title: Text('Error'),
            content: Text('Localization not available'),
          );
        }
        return AlertDialog(
          title: Text(
            localizations.selectLanguage,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(localizations.languageEnglish),
                onTap: () {
                  widget.onLanguageChange(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(localizations.languageSpanish),
                onTap: () {
                  widget.onLanguageChange(const Locale('es'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(localizations.languageHindi),
                onTap: () {
                  widget.onLanguageChange(const Locale('hi'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations?.appName ?? 'Drivana',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: Colors.white),
            onPressed: _showLanguageDialog,
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: localizations?.home ?? 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: localizations?.profile ?? 'Profile',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: localizations?.orders ?? 'Orders',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.payment),
            label: localizations?.transactions ?? 'Transactions',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber.shade300,
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(),
        onTap: _onItemTapped,
      ),
    );
  }
}
