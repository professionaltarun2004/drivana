import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CarCard3D extends StatelessWidget {
  final String model;
  final double price;
  final String imagePath;
  final String carId;
  final String city;
  final VoidCallback onBook;

  const CarCard3D({
    super.key,
    required this.model,
    required this.price,
    required this.imagePath,
    required this.carId,
    required this.city,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBook,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        height: 200,
        child: Transform(
          transform:
              Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Adds 3D perspective
                ..rotateX(0.02),
          alignment: Alignment.center,
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder:
                        (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue.shade700,
                          ),
                        ),
                    errorWidget:
                        (context, url, error) =>
                            Icon(Icons.error, color: Colors.red),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        '₹$price/day',
                        style: GoogleFonts.poppins(
                          color: Colors.amber.shade300,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        city,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: ElevatedButton(
                    onPressed: onBook,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    ),
                    child: Text(
                      'Book Now',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(duration: 600.ms).scale(begin: Offset(0.95, 0.95)),
    );
  }
}
