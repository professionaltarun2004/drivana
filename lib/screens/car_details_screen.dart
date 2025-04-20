import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'booking_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CarDetailsScreen extends StatelessWidget {
  final String? model;
  final double? price;
  final String? imageUrl; // Using imageUrl for asset path
  final String? carId;

  const CarDetailsScreen({super.key, this.model, this.price, this.imageUrl, this.carId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model ?? 'Car Details', style: GoogleFonts.poppins()),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imageUrl ?? 'assets/images/corolla_hatchback.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error, size: 100),
              ),
            ).animate().fadeIn(duration: 500.ms),
            SizedBox(height: 20),
            Text(
              model ?? 'Unknown',
              style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '\$${price?.toStringAsFixed(2) ?? '0.00'}/day',
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey.shade600),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingScreen(
                      carId: carId ?? 'dummy_id',
                      model: model,
                      car: {
                        'model': model,
                        'price': price,
                        'imageUrl': imageUrl,
                      },
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.blue.shade700,
              ),
              child: Text(
                'Book Now',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ).animate().scale(duration: 500.ms),
          ],
        ),
      ),
    );
  }
}