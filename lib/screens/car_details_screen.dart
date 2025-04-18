import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'booking_screen.dart';

class CarDetailsScreen extends StatelessWidget {
  final String? model;
  final double? price;
  final String? imageUrl;

  CarDetailsScreen({this.model, this.price, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(model ?? 'Car Details')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl != null
                ? Image.network(imageUrl!, height: 200, fit: BoxFit.cover)
                : Image.asset(
                  'assets/images/placeholder_car.jpg',
                  height: 200,
                  fit: BoxFit.cover,
                ),
            SizedBox(height: 20),
            Text(
              model ?? 'Unknown',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\$${price?.toStringAsFixed(2) ?? '0.00'}/day',
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            BookingScreen(carId: 'dummy_id', model: model),
                  ),
                );
              },
              child: Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }
}
