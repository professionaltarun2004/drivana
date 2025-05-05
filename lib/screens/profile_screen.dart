import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:vibration/vibration.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_tilt/flutter_tilt.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                  const Color.fromARGB(255, 203, 199, 220),
                  const Color.fromARGB(255, 220, 157, 157),
                  const Color.fromARGB(255, 101, 77, 77),
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
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                GlassmorphicContainer(
                  width: double.infinity,
                  height: 200,
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
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Tilt(
                          tiltConfig: const TiltConfig(
                            angle: 10,
                            moveDuration: Duration(milliseconds: 300),
                          ),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              const CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                  'https://via.placeholder.com/150',
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Vibration.vibrate(duration: 100);
                                  // TODO: Implement profile picture change
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade700,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.white,
                                highlightColor: Colors.blue.shade200,
                                child: Text(
                                  'John Doe',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                'john.doe@example.com',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.3),

                const SizedBox(height: 20),

                // Account Settings
                _buildSectionTitle('Account Settings'),
                _buildListTile(
                  context,
                  icon: Icons.edit,
                  title: 'Edit Profile',
                  onTap: () => Vibration.vibrate(duration: 100),
                ).animate().slideX(begin: -0.2, duration: 900.ms),
                _buildListTile(
                  context,
                  icon: Icons.lock,
                  title: 'Change Password',
                  onTap: () => Vibration.vibrate(duration: 100),
                ).animate().slideX(begin: -0.2, duration: 1000.ms),
                _buildListTile(
                  context,
                  icon: Icons.brightness_6,
                  title: 'Toggle Theme',
                  onTap: () => Vibration.vibrate(duration: 100),
                ).animate().slideX(begin: -0.2, duration: 1100.ms),
                _buildListTile(
                  context,
                  icon: Icons.logout,
                  title: 'Logout',
                  titleColor: Colors.red.shade700,
                  iconColor: Colors.red.shade700,
                  onTap: () => Vibration.vibrate(duration: 200),
                ).animate().slideX(begin: -0.2, duration: 1200.ms),

                const SizedBox(height: 20),

                // Recent Activity
                _buildSectionTitle('Recent Activity'),
                _buildCollapsibleSection(
                  context,
                  children: [
                    _buildActivityTile(
                      icon: Icons.car_rental,
                      title: 'Booked Honda Civic',
                      subtitle: 'Apr 19, 2025',
                    ),
                    const Divider(),
                    _buildActivityTile(
                      icon: Icons.payment,
                      title: 'Payment Completed',
                      subtitle: 'Apr 18, 2025',
                    ),
                  ],
                ).animate().fadeIn(duration: 1300.ms),

                const SizedBox(height: 20),

                // Saved Addresses
                _buildSectionTitle('Saved Addresses'),
                _buildListTile(
                  context,
                  icon: Icons.location_on,
                  title: '123 Main St, Hyderabad',
                  trailing: const Icon(Icons.edit, color: Colors.blue),
                  onTap: () => Vibration.vibrate(duration: 100),
                ).animate().fadeIn(duration: 1400.ms),

                const SizedBox(height: 20),

                // Payment Methods
                _buildSectionTitle('Payment Methods'),
                _buildCollapsibleSection(
                  context,
                  children: [
                    _buildPaymentTile(
                      context,
                      icon: Icons.payment,
                      title: 'UPI',
                      isSelected: true,
                      onTap: () => Vibration.vibrate(duration: 100),
                    ),
                    const Divider(),
                    _buildPaymentTile(
                      context,
                      icon: Icons.money,
                      title: 'Cash',
                      isSelected: false,
                      onTap: () => Vibration.vibrate(duration: 100),
                    ),
                    const Divider(),
                    _buildPaymentTile(
                      context,
                      icon: Icons.credit_card,
                      title: 'Others',
                      isSelected: false,
                      onTap: () => Vibration.vibrate(duration: 100),
                    ),
                  ],
                ).animate().fadeIn(duration: 1500.ms),
              ],
            ),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton:
          FloatingActionButton(
            onPressed: () => Vibration.vibrate(duration: 200),
            backgroundColor: Colors.blue.shade700,
            child: const Icon(Icons.edit, color: Colors.white),
          ).animate().fadeIn(duration: 1600.ms).scale(),
    );
  }

  // Section Title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        shadows: [
          Shadow(
            blurRadius: 8,
            color: Colors.blue.shade300.withOpacity(0.5),
            offset: const Offset(0, 2),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 700.ms);
  }

  // List Tile
  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    Color? titleColor,
    Color? iconColor,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Icon(icon, color: iconColor ?? Colors.blue.shade300),
          title: Text(
            title,
            style: GoogleFonts.montserrat(
              color: titleColor ?? Colors.white,
              fontSize: 16,
            ),
          ),
          trailing:
              trailing ??
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: 16,
              ),
        ),
      ),
    );
  }

  // Collapsible Section
  Widget _buildCollapsibleSection(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 200,
      borderRadius: 12,
      blur: 20,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
      ),
      borderGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.5), Colors.blue.withOpacity(0.2)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: IntrinsicHeight(child: Column(children: children)),
      ),
    );
  }

  // Activity Tile
  Widget _buildActivityTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(icon, color: Colors.blue.shade300),
      title: Text(title, style: GoogleFonts.montserrat(color: Colors.white)),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.montserrat(color: Colors.white70),
      ),
    );
  }

  // Payment Tile
  Widget _buildPaymentTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.green : Colors.white),
      title: Text(
        title,
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing:
          isSelected
              ? const Icon(Icons.check_circle, color: Colors.green)
              : const Icon(Icons.radio_button_unchecked, color: Colors.white),
      onTap: onTap,
    );
  }
}

// Dummy Particle Painter (you can enhance this as needed)
class ParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    final paint = Paint()..color = Colors.white.withOpacity(0.05);

    for (int i = 0; i < 100; i++) {
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2;
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
