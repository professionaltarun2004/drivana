import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:vibration/vibration.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:shimmer/shimmer.dart';
import '../services/firestore_service.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();
    const userId =
        'sample_user_id'; // TODO: Replace with actual userId from auth

    return Scaffold(
      body: Stack(
        children: [
          // Dynamic Gradient Background
          AnimatedContainer(
            duration: const Duration(seconds: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.deepPurple, Colors.blue, Colors.purple],
              ),
            ),
          ),
          // Subtle Particle Animation
          PlayAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(seconds: 20),
            builder: (context, value, child) {
              return CustomPaint(
                painter: ParticlePainter(),
                size: Size.infinite,
              );
            },
          ),
          // Main Content
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
            },
            color: Colors.blue,
            backgroundColor: Colors.white,
            child: StreamBuilder<QuerySnapshot>(
              stream: firestoreService.getUserBookings(userId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error fetching orders: ${snapshot.error}',
                      style: GoogleFonts.montserrat(
                        color: Colors.redAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: Shimmer(
                      gradient: LinearGradient(
                        colors: [Colors.grey, Colors.white, Colors.grey],
                      ),
                      child: CircularProgressIndicator(color: Colors.blue),
                    ),
                  );
                }

                final bookings = snapshot.data!.docs;

                if (bookings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const _FadeInWidget(
                          child: Icon(
                            Icons.car_rental,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'No orders found',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _FadeInWidget(
                          child: GestureDetector(
                            onTap: () {
                              Vibration.vibrate(duration: 100);
                              // TODO: Navigate to booking screen
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.blue, Colors.purple],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.blue,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                'Book a Car Now',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: bookings.length + 1, // +1 for summary card
                  itemExtent: 200, // Fixed height for smooth scrolling
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _FadeInWidget(
                        child: _buildSummaryCard(bookings.length),
                      );
                    }
                    final bookingIndex = index - 1;
                    final booking =
                        bookings[bookingIndex].data() as Map<String, dynamic>;
                    return _FadeInWidget(
                      delay: (bookingIndex + 1) * 100,
                      child: _buildOrderCard(
                        context,
                        orderId: bookings[bookingIndex].id,
                        booking: booking,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _FadeInWidget(
        child: FloatingActionButton(
          onPressed: () {
            Vibration.vibrate(duration: 200);
            // TODO: Implement filter/sort orders
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.filter_list, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(int totalOrders) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 120,
      borderRadius: 12,
      blur: 20,
      alignment: Alignment.center,
      border: 2,
      linearGradient: const LinearGradient(
        colors: [Colors.white, Colors.white],
      ),
      borderGradient: const LinearGradient(colors: [Colors.white, Colors.blue]),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total Orders',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Shimmer(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Colors.blue, Colors.white],
                  ),
                  child: Text(
                    '$totalOrders',
                    style: GoogleFonts.montserrat(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const Icon(Icons.receipt_long, color: Colors.blue, size: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context, {
    required String orderId,
    required Map<String, dynamic> booking,
  }) {
    final startDate =
        booking['startDate'] is Timestamp
            ? (booking['startDate'] as Timestamp).toDate().toString().substring(
              0,
              10,
            )
            : 'N/A';
    final endDate =
        booking['endDate'] is Timestamp
            ? (booking['endDate'] as Timestamp).toDate().toString().substring(
              0,
              10,
            )
            : 'N/A';

    return GestureDetector(
      onTap: () {
        Vibration.vibrate(duration: 100);
        // TODO: Navigate to order details
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: GlassmorphicContainer(
          width: double.infinity,
          height: 180,
          borderRadius: 12,
          blur: 20,
          alignment: Alignment.center,
          border: 2,
          linearGradient: const LinearGradient(
            colors: [Colors.white, Colors.white],
          ),
          borderGradient: const LinearGradient(
            colors: [Colors.white, Colors.blue],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order #$orderId',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.green, Colors.green],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Delivered',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Car ID: ${booking['carId'] ?? 'N/A'}',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  'Start: $startDate',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  'End: $endDate',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildButton(
                      context,
                      text: 'Reorder',
                      gradient: const LinearGradient(
                        colors: [Colors.amber, Colors.amber],
                      ),
                      onTap: () {
                        Vibration.vibrate(duration: 100);
                        // TODO: Implement reorder
                      },
                    ),
                    _buildButton(
                      context,
                      text: 'View Details',
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                      ),
                      onTap: () {
                        Vibration.vibrate(duration: 100);
                        // TODO: Implement view details
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String text,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Colors.blue, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
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

// Custom Fade-In Widget using AnimatedOpacity
class _FadeInWidget extends StatefulWidget {
  final Widget child;
  final int delay;

  const _FadeInWidget({required this.child, this.delay = 0});

  @override
  _FadeInWidgetState createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<_FadeInWidget> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 600),
      child: widget.child,
    );
  }
}
