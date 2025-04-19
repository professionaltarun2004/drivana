import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/firestore_service.dart';
import '../widgets/car_card.dart';
import 'filter_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  Map<String, dynamic> _filters = {};

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _filters = filters;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rent-a-Car',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.amber.shade300),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterScreen(onApply: _applyFilters),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.1,
            child: Lottie.network(
              'https://assets.lottiefiles.com/packages/lf20_uwos7gfy.json',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder:
                  (context, error, stackTrace) =>
                      Container(color: Colors.grey.shade200),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _firestoreService.getCars(
              city: _filters['city'],
              carType: _filters['carType'],
              condition: _filters['condition'],
              fuel: _filters['fuel'],
              pickupDate: _filters['pickupDate'],
              duration: _filters['duration'],
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading cars',
                    style: GoogleFonts.poppins(color: Colors.red),
                  ),
                );
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final cars = snapshot.data!.docs;

              if (cars.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.network(
                        'https://assets.lottiefiles.com/packages/lf20_kploitgp.json',
                        width: 200,
                        height: 200,
                        errorBuilder:
                            (context, error, stackTrace) => Icon(Icons.error),
                      ),
                      Text(
                        'No cars available',
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                    ],
                  ),
                );
              }

              final filteredCars =
                  cars.where((car) {
                    final data = car.data() as Map<String, dynamic>;
                    bool matches = true;
                    if (_filters['pickupDate'] != null) {
                      matches = true; // Client-side date logic placeholder
                    }
                    if (_filters['duration'] != null) {
                      matches = true; // Client-side duration logic placeholder
                    }
                    return matches;
                  }).toList();

              return SingleChildScrollView(
                child: Column(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 220.0,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.85,
                      ),
                      items:
                          filteredCars.map((car) {
                            final data = car.data() as Map<String, dynamic>;
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: data['image_path'],
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (context, url) =>
                                              CircularProgressIndicator(),
                                      errorWidget:
                                          (context, url, error) =>
                                              Icon(Icons.error),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                    ).animate().fadeIn(duration: 600.ms),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children:
                            filteredCars.map((car) {
                              final data = car.data() as Map<String, dynamic>;
                              return CarCard(
                                model: data['model'],
                                price: (data['price'] as num).toDouble(),
                                imagePath: data['image_path'],
                                carId: car.id,
                                city: data['city'],
                              );
                            }).toList(),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await _firestoreService.seedCars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Cars seeded successfully!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.amber.shade300,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Seed Cars (Run Once)',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ).animate().fadeIn(duration: 400.ms),
                    SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
