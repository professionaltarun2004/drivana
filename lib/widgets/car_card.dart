import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../screens/car_details_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CarCard extends StatelessWidget {
  final String model;
  final double price;
  final String imagePath;
  final String carId;
  final String city;

  CarCard({
    required this.model,
    required this.price,
    required this.imagePath,
    required this.carId,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => CarDetailsScreen(
                  model: model,
                  price: price,
                  imageUrl: imagePath,
                  carId: carId,
                ),
          ),
        );
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: imagePath,
                  width: 100,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      city,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '\$${price.toStringAsFixed(2)}/day',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.amber.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.blue.shade700,
                size: 20,
              ),
              SizedBox(width: 16),
            ],
          ),
        ),
      ).animate().scale(duration: 300.ms, curve: Curves.easeInOut),
    );
  }
}
