// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/firestore_service.dart';
import '../widgets/car_card.dart';
import 'filter_screen.dart';
import 'booking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  Map<String, dynamic> _filters = {};
  String _selectedFilter = 'All';
  final List<String> _filterOptions = [
    'All',
    'Price: Low to High',
    'Price: High to Low',
    'Rating',
  ];
  final DateTime _offerEndTime = DateTime.now().add(const Duration(hours: 12));
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filters = {
      'city': 'Hyderabad',
      'carType': null,
      'condition': null,
      'fuel': null,
      'pickupDate': null,
      'duration': null,
    };
    _firestoreService.checkAndSeedCars(_filters['city']!);
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _filters = {
        ...filters,
        'city':
            filters['city']?.isEmpty ?? true ? 'Hyderabad' : filters['city'],
      };
      _firestoreService.checkAndSeedCars(_filters['city']!);
    });
  }

  Map<String, dynamic> _extractCarData(QueryDocumentSnapshot car) {
    final data = car.data() as Map<String, dynamic>? ?? {};
    return {
      'id': car.id,
      'model': data['model'] ?? 'Unknown Model',
      'price': (data['price'] as num?)?.toDouble() ?? 0.0,
      'imagePath': data['imagePath'] ?? 'https://picsum.photos/200/300',
      'city': data['city'] ?? _filters['city'] ?? 'Unknown',
      'rating': (data['rating'] as num?)?.toDouble() ?? 0.0,
    };
  }

  void _navigateToBooking(Map<String, dynamic> carData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => BookingScreen(
              carId: carData['id'],
              model: carData['model'],
              car: carData,
            ),
      ),
    );
  }

  Widget _buildCarCard(Map<String, dynamic> carData) => CarCard3D(
    model: carData['model'] as String? ?? 'Unknown Model',
    price: carData['price'] as double? ?? 0.0,
    imagePath:
        carData['imagePath'] as String? ?? 'https://picsum.photos/200/300',
    carId: carData['id'] as String? ?? '',
    city: carData['city'] as String? ?? 'Unknown',
    onBook: () => _navigateToBooking(carData),
  );

  Widget _buildErrorState(String message) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 50),
        const SizedBox(height: 10),
        Text(
          message,
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Colors.red,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {}); // Retry fetching cars
          },
          style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll(Colors.blue),
            foregroundColor: const MaterialStatePropertyAll(Colors.white),
            padding: const MaterialStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          child: const Text('Retry', style: TextStyle(fontFamily: 'Poppins')),
        ),
      ],
    ),
  );

  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const Icon(
          Icons.car_rental,
          size: 100,
          color: Colors.grey,
        ).animate().fade(duration: const Duration(milliseconds: 600)),
        Text(
          'No cars found in ${_filters['city'] ?? 'selected city'}',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Try adjusting filters or seeding cars.',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            try {
              await _firestoreService.seedCars(_filters['city']!);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Cars seeded for ${_filters['city']}!'),
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error seeding cars: $e')),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Seed Cars Now',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildCarousel(List<Map<String, dynamic>> cars) => CarouselSlider(
    options: CarouselOptions(
      height: 200,
      autoPlay: true,
      enlargeCenterPage: true,
      viewportFraction: 0.8,
      aspectRatio: 16 / 9,
      autoPlayInterval: const Duration(seconds: 3),
    ),
    items:
        cars.map((carData) {
          final imagePath =
              carData['imagePath'] as String? ??
              'https://picsum.photos/200/300';
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                    placeholder:
                        (_, __) => const Center(
                          child: CircularProgressIndicator(color: Colors.blue),
                        ),
                    errorWidget: (context, url, error) {
                      if (kDebugMode) {
                        print(
                          'Image load error for ${carData['model']} at $url: $error',
                        );
                      }
                      return const Center(
                        child: Icon(Icons.error, color: Colors.red, size: 40),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Text(
                      carData['model'] ?? 'Unknown Model',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
  ).animate().fadeIn(duration: const Duration(milliseconds: 600));

  Widget _buildRefreshButton() => SliverToBoxAdapter(
    child: Center(
      child: ElevatedButton(
        onPressed: () async {
          try {
            await _firestoreService.seedCars(_filters['city']!);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cars seeded for ${_filters['city']}!')),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error seeding cars: $e')));
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.amber.shade300,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        child: const Text(
          'Refresh Car Data',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    ).animate().fade(
      duration: const Duration(milliseconds: 400),
      begin: 0,
      end: 1,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              'Drivana',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.blue.shade700,
            floating: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.white),
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => FilterScreen(
                              onApplyFilters: _applyFilters,
                              initialFilters: _filters,
                            ),
                      ),
                    ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blue.shade700,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search cars...',
                    hintStyle: const TextStyle(fontFamily: 'Poppins'),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Opacity(
                  opacity: 0.1,
                  child: Image.asset(
                    'assets/audi_suv.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    errorBuilder:
                        (_, __, ___) => Container(color: Colors.grey.shade200),
                  ).animate().fadeIn(
                    duration: const Duration(milliseconds: 600),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.red, Colors.red],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(blurRadius: 10, color: Colors.black26),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Deal of the Day!',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                '50% OFF First Booking',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              StreamBuilder(
                                stream: Stream.periodic(
                                  const Duration(seconds: 1),
                                  (count) => count,
                                ),
                                builder: (context, snapshot) {
                                  final duration = _offerEndTime.difference(
                                    DateTime.now(),
                                  );
                                  return Text(
                                    duration.isNegative
                                        ? 'Offer Expired'
                                        : 'Ends in ${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ).animate().slideX(
                            begin: -0.2,
                            duration: const Duration(milliseconds: 600),
                          ),
                          const Icon(
                            Icons.local_offer,
                            color: Colors.white,
                            size: 40,
                          ).animate().fade(
                            duration: const Duration(milliseconds: 800),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              _filterOptions.map((filter) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    label: Text(
                                      filter,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                      ),
                                    ),
                                    selected: _selectedFilter == filter,
                                    onSelected:
                                        (selected) => setState(
                                          () => _selectedFilter = filter,
                                        ),
                                    selectedColor: Colors.blue.shade700,
                                    backgroundColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color:
                                          _selectedFilter == filter
                                              ? Colors.white
                                              : Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: const BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ).animate().fade(
                      duration: const Duration(milliseconds: 600),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Text(
                        'Recommended for You',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 220,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestoreService.getCars(
                          city: _filters['city'],
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            if (kDebugMode) {
                              print(
                                'Recommended cars error: ${snapshot.error}',
                              );
                            }
                            return const Center(
                              child: Text('Error loading recommended cars'),
                            );
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Text('No recommended cars'),
                            );
                          }
                          final cars =
                              snapshot.data!.docs
                                  .take(5)
                                  .map(_extractCarData)
                                  .toList();
                          print('Recommended cars fetched: ${cars.length}');
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: cars.length,
                            itemBuilder:
                                (context, index) => Padding(
                                  padding: EdgeInsets.only(
                                    left: 16,
                                    right: index == cars.length - 1 ? 16 : 0,
                                  ),
                                  child: _buildCarCard(cars[index]),
                                ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ],
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
              if (snapshot.connectionState == ConnectionState.waiting) {
                print('StreamBuilder: Waiting for data...');
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.blue),
                  ),
                );
              }
              if (snapshot.hasError) {
                if (kDebugMode) {
                  print('Firestore error: ${snapshot.error}');
                }
                final message =
                    snapshot.error.toString().contains('permission-denied')
                        ? 'Permission denied. Please check Firestore rules and retry.'
                        : 'Error fetching cars: ${snapshot.error}';
                return SliverFillRemaining(child: _buildErrorState(message));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                print('StreamBuilder: No data or empty docs');
                return SliverFillRemaining(child: _buildEmptyState());
              }
              final cars = snapshot.data!.docs.map(_extractCarData).toList();
              print(
                'StreamBuilder: Fetched ${cars.length} cars for city: ${_filters['city']} with filters: $_filters',
              );
              final filteredCars =
                  cars
                      .where(
                        (car) =>
                            _searchQuery.isEmpty ||
                            (car['model']?.toLowerCase() ?? '').contains(
                              _searchQuery,
                            ),
                      )
                      .toList();
              if (_selectedFilter == 'Price: Low to High') {
                filteredCars.sort((a, b) => a['price'].compareTo(b['price']));
              } else if (_selectedFilter == 'Price: High to Low') {
                filteredCars.sort((a, b) => b['price'].compareTo(a['price']));
              } else if (_selectedFilter == 'Rating') {
                filteredCars.sort(
                  (a, b) => (b['rating'] ?? 0.0).compareTo(a['rating'] ?? 0.0),
                );
              }
              return SliverList(
                delegate: SliverChildListDelegate([
                  SliverToBoxAdapter(child: _buildCarousel(filteredCars)),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildCarCard(filteredCars[index]),
                        childCount: filteredCars.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  _buildRefreshButton(),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                ]),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
