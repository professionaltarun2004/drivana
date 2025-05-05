// // ignore_for_file: library_private_types_in_public_api

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart' as local_auth;
// import 'signup_screen.dart';
// import 'package:flutter_animate/flutter_animate.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   String? _errorMessage;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _login() async {
//     setState(() {
//       _errorMessage = null;
//     });
//     try {
//       await Provider.of<local_auth.AuthProvider>(
//         context,
//         listen: false,
//       ).signIn(_emailController.text.trim(), _passwordController.text);
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         _errorMessage = _mapFirebaseError(e.code);
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Login failed: ${e.toString()}';
//       });
//     }
//   }

//   String _mapFirebaseError(String code) {
//     switch (code) {
//       case 'user-not-found':
//         return 'No user found with this email.';
//       case 'wrong-password':
//         return 'Incorrect password.';
//       case 'invalid-email':
//         return 'Invalid email address.';
//       default:
//         return 'An error occurred: $code';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Login',
//                 style: GoogleFonts.poppins(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue.shade700,
//                 ),
//               ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2),
//               const SizedBox(height: 20),
//               if (_errorMessage != null)
//                 Text(
//                   _errorMessage!,
//                   style: GoogleFonts.poppins(color: Colors.red),
//                 ).animate().shake(),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   prefixIcon: const Icon(Icons.email),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//               ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   prefixIcon: const Icon(Icons.lock),
//                 ),
//                 obscureText: true,
//               ).animate().fadeIn(duration: 700.ms).slideX(begin: -0.1),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _login,
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 40,
//                     vertical: 15,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   backgroundColor: Colors.blue.shade700,
//                 ),
//                 child: Text(
//                   'Login',
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ).animate().fadeIn(duration: 800.ms).scale(),
//               const SizedBox(height: 10),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => SignupScreen()),
//                   );
//                 },
//                 child: Text(
//                   'Create an account',
//                   style: GoogleFonts.poppins(color: Colors.blue.shade700),
//                 ),
//               ).animate().fadeIn(duration: 900.ms),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:vibration/vibration.dart'; // Updated import
import 'package:simple_animations/simple_animations.dart';
import '../providers/auth_provider.dart' as local_auth;
import 'signup_screen.dart';
import 'dart:math'; // For Random in ParticlePainter

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    try {
      await Provider.of<local_auth.AuthProvider>(
        context,
        listen: false,
      ).signIn(_emailController.text.trim(), _passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _mapFirebaseError(e.code);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Login failed: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Invalid email address.';
      default:
        return 'An error occurred: $code';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dynamic Gradient Background
          AnimatedContainer(
            duration: const Duration(seconds: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.deepPurple.shade900,
                  Colors.blue.shade700,
                  Colors.purple.shade600,
                ],
              ),
            ),
          ),
          // Subtle Particle Animation
          PlayAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(seconds: 20),
            builder: (context, value, child) {
              return CustomPaint(
                painter: ParticlePainter(),
                child: Container(),
              );
            },
          ),
          // Main Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: GlassmorphicContainer(
                  width: double.infinity,
                  height: 600,
                  borderRadius: 20,
                  blur: 20,
                  alignment: Alignment.center,
                  border: 2,
                  linearGradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  borderGradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.5),
                      Colors.blue.withOpacity(0.2),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title
                        Text(
                              'Welcome Back',
                              style: GoogleFonts.montserrat(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10,
                                    color: Colors.blue.shade300.withOpacity(
                                      0.5,
                                    ),
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 800.ms)
                            .slideY(begin: -0.3),
                        const SizedBox(height: 16),
                        // Error Message
                        if (_errorMessage != null)
                          Text(
                            _errorMessage!,
                            style: GoogleFonts.montserrat(
                              color: Colors.redAccent,
                              fontSize: 14,
                            ),
                          ).animate().shake(duration: 400.ms),
                        const SizedBox(height: 24),
                        // Email Field
                        _buildTextField(
                              controller: _emailController,
                              label: 'Email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            )
                            .animate()
                            .fadeIn(duration: 900.ms)
                            .slideX(begin: -0.2),
                        const SizedBox(height: 16),
                        // Password Field
                        _buildTextField(
                              controller: _passwordController,
                              label: 'Password',
                              icon: Icons.lock_outline,
                              obscureText: true,
                            )
                            .animate()
                            .fadeIn(duration: 1000.ms)
                            .slideX(begin: 0.2),
                        const SizedBox(height: 16),
                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Vibration.vibrate(duration: 100); // Updated
                              // TODO: Implement forgot password logic
                            },
                            child: Text(
                              'Forgot Password?',
                              style: GoogleFonts.montserrat(
                                color: Colors.blue.shade300,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ).animate().fadeIn(duration: 1100.ms),
                        const SizedBox(height: 24),
                        // Login Button
                        GestureDetector(
                              onTap:
                                  _isLoading
                                      ? null
                                      : () {
                                        Vibration.vibrate(
                                          duration: 200,
                                        ); // Updated
                                        _login();
                                      },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.shade600,
                                      Colors.purple.shade600,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.shade400.withOpacity(
                                        0.4,
                                      ),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 16,
                                ),
                                child:
                                    _isLoading
                                        ? const SpinKitThreeBounce(
                                          color: Colors.white,
                                          size: 24,
                                        )
                                        : Text(
                                          'Login',
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 1200.ms)
                            .scale(delay: 1000.ms),
                        const SizedBox(height: 16),
                        // Signup Link
                        TextButton(
                          onPressed: () {
                            Vibration.vibrate(duration: 100); // Updated
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, _) =>
                                        const SignupScreen(),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Text(
                            'Create an account',
                            style: GoogleFonts.montserrat(
                              color: Colors.blue.shade300,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ).animate().fadeIn(duration: 1300.ms),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.montserrat(
            color: Colors.white.withOpacity(0.7),
          ),
          prefixIcon: Icon(icon, color: Colors.blue.shade300),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          floatingLabelStyle: GoogleFonts.montserrat(
            color: Colors.blue.shade300,
          ),
        ),
        style: GoogleFonts.montserrat(color: Colors.white),
        obscureText: obscureText,
        keyboardType: keyboardType,
      ),
    );
  }
}

// Particle Animation Painter
class ParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.1);
    final random = Random();
    for (int i = 0; i < 50; i++) {
      canvas.drawCircle(
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        random.nextDouble() * 2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
