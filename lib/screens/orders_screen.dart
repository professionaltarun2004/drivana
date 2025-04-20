import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../services/firestore_service.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();
    // TODO: Replace with actual userId from auth
    const userId = 'sample_user_id';

    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.getUserBookings(userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error fetching orders: ${snapshot.error}',
              style: GoogleFonts.poppins(color: Colors.red, fontSize: 16),
            ),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(color: Colors.blue.shade700),
          );
        }

        final bookings = snapshot.data!.docs;

        if (bookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.network(
                  'https://assets.lottiefiles.com/packages/lf20_kploitgp.json',
                  width: 200,
                  height: 200,
                ),
                Text(
                  'No orders found',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index].data() as Map<String, dynamic>;
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order #${bookings[index].id}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Delivered',
                          style: GoogleFonts.poppins(
                            color: Colors.green.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Car ID: ${booking['carId']}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    'Start: ${booking['startDate']?.toDate().toString().substring(0, 10) ?? 'N/A'}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    'End: ${booking['endDate']?.toDate().toString().substring(0, 10) ?? 'N/A'}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement reorder
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade300,
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Reorder',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement view details
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'View Details',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2);
          },
        );
      },
    );
  }
}
