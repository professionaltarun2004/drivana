import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Car Rental App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(bodyMedium: TextStyle(fontFamily: 'Poppins')),
        ),
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return auth.user != null ? HomeScreen() : LoginScreen();
          },
        ),
      ),
    );
  }
}
