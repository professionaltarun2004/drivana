// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/foundation.dart';

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
    return SizedBox(
          width: 300, // Define a fixed width to constrain the card
          height: 200, // Match the height defined in the Container
          child: GestureDetector(
            onTap: onBook,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Transform(
                transform:
                    Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(0.02),
                alignment: Alignment.center,
                child: Card(
                  elevation: 0, // Elevation is handled by the boxShadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child:
                            imagePath.startsWith('assets/')
                                ? Image.asset(
                                  imagePath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    if (kDebugMode) {
                                      print(
                                        'Asset load error for $model at $imagePath: $error',
                                      );
                                    }
                                    return Container(
                                      color: Colors.grey.shade200,
                                      child: const Center(
                                        child: Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                      ),
                                    );
                                  },
                                )
                                : CachedNetworkImage(
                                  imageUrl: imagePath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  placeholder:
                                      (context, url) => const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.blue,
                                        ),
                                      ),
                                  errorWidget: (context, url, error) {
                                    if (kDebugMode) {
                                      print(
                                        'Image load error for $model at $url: $error',
                                      );
                                    }
                                    return Container(
                                      color: Colors.grey.shade200,
                                      child: const Center(
                                        child: Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                      ),
                                    );
                                  },
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
                              model.isNotEmpty ? model : 'Unknown Model',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${(price * (1 + 0.1)).toStringAsFixed(2)}/day',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.amberAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              city.isNotEmpty ? city : 'Unknown City',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                          ),
                          child: const Text(
                            'Book Now',
                            style: TextStyle(
                              fontFamily: 'Poppins',
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
            ),
          ),
        )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 600))
        .scale(begin: const Offset(0.95, 0.95));
  }
}
