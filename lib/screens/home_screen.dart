// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/firestore_service.dart';
import '../widgets/car_card.dart';
import 'filter_screen.dart';
import 'booking_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  Map<String, dynamic> _filters = {'city': 'Hyderabad'};
  String _selectedFilter = 'All';
  final List<String> _filterOptions = [
    'All',
    'Price: Low to High',
    'Price: High to Low',
    'Rating',
  ];
  final _offerEndTime = DateTime.now().add(Duration(hours: 12));
  final bool _isGridView = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firestoreService.checkAndSeedCars(
      _filters['city'] as String? ?? 'Hyderabad',
    );
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _filters = Map<String, dynamic>.from(filters);
      if (_filters['city'] == null || (_filters['city'] as String).isEmpty) {
        _filters['city'] = 'Hyderabad';
      }
      _firestoreService.checkAndSeedCars(
        _filters['city'] as String? ?? 'Hyderabad',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Drivana',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => FilterScreen(
                        onApplyFilters: _applyFilters,
                        initialFilters: _filters,
                      ),
                ),
              );
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
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.blue.shade700,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search cars...',
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey.shade300,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (value) {
                            // TODO: Implement search logic
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade600, Colors.red.shade800],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(blurRadius: 10, color: Colors.black26),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deal of the Day!',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '50% OFF First Booking',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          StreamBuilder(
                            stream: Stream.periodic(
                              Duration(seconds: 1),
                              (i) => i,
                            ),
                            builder: (context, snapshot) {
                              final duration = _offerEndTime.difference(
                                DateTime.now(),
                              );
                              if (duration.isNegative) {
                                return Text(
                                  'Offer Expired',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                );
                              }
                              final hours = duration.inHours;
                              final minutes = duration.inMinutes % 60;
                              final seconds = duration.inSeconds % 60;
                              return Text(
                                'Ends in $hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              );
                            },
                          ),
                        ],
                      ).animate().slideX(begin: -0.2, duration: 600.ms),
                      Icon(
                        Icons.local_offer,
                        color: Colors.white,
                        size: 40,
                      ).animate().fadeIn(duration: 800.ms),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          _filterOptions
                              .map(
                                (filter) => Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    label: Text(
                                      filter,
                                      style: GoogleFonts.poppins(fontSize: 14),
                                    ),
                                    selected: _selectedFilter == filter,
                                    onSelected: (selected) {
                                      if (selected) {
                                        setState(
                                          () => _selectedFilter = filter,
                                        );
                                      }
                                    },
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
                                      side: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ).animate().fadeIn(duration: 600.ms),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Recommended for You',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestoreService.getCars(
                      city: _filters['city'] as String?,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) return SizedBox.shrink();
                      if (!snapshot.hasData) return SizedBox.shrink();
                      final cars = snapshot.data!.docs;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: cars.length > 5 ? 5 : cars.length,
                        itemBuilder: (context, index) {
                          final car = cars[index];
                          final data =
                              car.data() as Map<String, dynamic>? ?? {};
                          return Padding(
                            padding: EdgeInsets.only(
                              left: 16,
                              right: index == 4 ? 16 : 0,
                            ),
                            child: CarCard3D(
                              model:
                                  data['model'] as String? ?? 'Unknown Model',
                              price: (data['price'] as num?)?.toDouble() ?? 0.0,
                              imagePath:
                                  data['imagePath'] as String? ??
                                  'https://via.placeholder.com/300',
                              carId: car.id,
                              city:
                                  data['city'] as String? ??
                                  _filters['city'] as String? ??
                                  'Unknown',
                              onBook: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => BookingScreen(
                                          carId: car.id,
                                          model:
                                              data['model'] as String? ??
                                              'Unknown',
                                          car: {
                                            'id': car.id,
                                            'model':
                                                data['model'] as String? ??
                                                'Unknown',
                                            'price':
                                                data['price'] as num? ?? 0.0,
                                            'imagePath':
                                                data['imagePath'] as String? ??
                                                'https://via.placeholder.com/300',
                                            'city':
                                                data['city'] as String? ??
                                                _filters['city'] as String? ??
                                                'Unknown',
                                          },
                                        ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestoreService.getCars(
                    city: _filters['city'] as String?,
                    carType: _filters['carType'] as String?,
                    condition: _filters['condition'] as String?,
                    fuel: _filters['fuel'] as String?,
                    pickupDate: _filters['pickupDate'] as DateTime?,
                    duration: _filters['duration'] as int?,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      if (kDebugMode) {
                        print('Firestore error: ${snapshot.error}');
                      }
                      String errorMessage =
                          'Error fetching cars: ${snapshot.error}';
                      if (snapshot.error.toString().contains(
                        'permission-denied',
                      )) {
                        errorMessage =
                            'Permission denied. Please check Firestore rules and retry.';
                      }
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 50,
                            ),
                            SizedBox(height: 10),
                            Text(
                              errorMessage,
                              style: GoogleFonts.poppins(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                _firestoreService.checkAndSeedCars(
                                  _filters['city'] as String? ?? 'Hyderabad',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Retry',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue.shade700,
                        ),
                      );
                    }

                    final cars = snapshot.data!.docs;
                    if (kDebugMode) {
                      print(
                      'Fetched ${cars.length} cars for city: ${_filters['city']} with filters: $_filters',
                    );
                    }

                    if (cars.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            Lottie.network(
                              'https://assets.lottiefiles.com/packages/lf20_kploitgp.json',
                              width: 200,
                              height: 200,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      Icon(Icons.error, size: 50),
                            ),
                            Text(
                              'No cars found in ${_filters['city'] ?? 'selected city'}',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Try adjusting filters or seeding cars.',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  await _firestoreService.seedCars(
                                    _filters['city'] as String? ?? 'Hyderabad',
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Cars seeded for ${_filters['city'] ?? 'Hyderabad'}!',
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error seeding cars: $e'),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Seed Cars Now',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    var filteredCars = cars.toList();

                    if (_selectedFilter == 'Price: Low to High') {
                      filteredCars.sort((a, b) {
                        final aPrice =
                            (a.data() as Map<String, dynamic>)['price']
                                as num? ??
                            0;
                        final bPrice =
                            (b.data() as Map<String, dynamic>)['price']
                                as num? ??
                            0;
                        return aPrice.compareTo(bPrice);
                      });
                    } else if (_selectedFilter == 'Price: High to Low') {
                      filteredCars.sort((a, b) {
                        final aPrice =
                            (a.data() as Map<String, dynamic>)['price']
                                as num? ??
                            0;
                        final bPrice =
                            (b.data() as Map<String, dynamic>)['price']
                                as num? ??
                            0;
                        return bPrice.compareTo(aPrice);
                      });
                    } else if (_selectedFilter == 'Rating') {
                      // TODO: Implement rating-based sorting
                    }

                    return Column(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 200.0,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 0.8,
                            aspectRatio: 16 / 9,
                            autoPlayInterval: Duration(seconds: 3),
                          ),
                          items:
                              filteredCars.map((car) {
                                final data = car.data() as Map<String, dynamic>;
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
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
                                              imageUrl:
                                                  data['imagePath']
                                                      as String? ??
                                                  'https://via.placeholder.com/300',
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: 200,
                                              placeholder:
                                                  (context, url) => Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                          color:
                                                              Colors
                                                                  .blue
                                                                  .shade700,
                                                        ),
                                                  ),
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                    Icons.error,
                                                    color: Colors.red,
                                                  ),
                                            ),
                                            Positioned(
                                              bottom: 10,
                                              left: 10,
                                              child: Text(
                                                data['model'] as String? ??
                                                    'Unknown Model',
                                                style: GoogleFonts.poppins(
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
                                  },
                                );
                              }).toList(),
                        ).animate().fadeIn(duration: 600.ms),
                        SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child:
                              _isGridView
                                  ? GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 16,
                                          mainAxisSpacing: 16,
                                          childAspectRatio: 0.75,
                                        ),
                                    itemCount: filteredCars.length,
                                    itemBuilder: (context, index) {
                                      final car = filteredCars[index];
                                      final data =
                                          car.data() as Map<String, dynamic>? ??
                                          {};
                                      return CarCard3D(
                                        model:
                                            data['model'] as String? ??
                                            'Unknown Model',
                                        price:
                                            (data['price'] as num?)
                                                ?.toDouble() ??
                                            0.0,
                                        imagePath:
                                            data['imagePath'] as String? ??
                                            'https://via.placeholder.com/300',
                                        carId: car.id,
                                        city:
                                            data['city'] as String? ??
                                            _filters['city'] as String? ??
                                            'Unknown',
                                        onBook: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => BookingScreen(
                                                    carId: car.id,
                                                    model:
                                                        data['model']
                                                            as String? ??
                                                        'Unknown',
                                                    car: {
                                                      'id': car.id,
                                                      'model':
                                                          data['model']
                                                              as String? ??
                                                          'Unknown',
                                                      'price':
                                                          data['price']
                                                              as num? ??
                                                          0.0,
                                                      'imagePath':
                                                          data['imagePath']
                                                              as String? ??
                                                          'https://via.placeholder.com/300',
                                                      'city':
                                                          data['city']
                                                              as String? ??
                                                          _filters['city']
                                                              as String? ??
                                                          'Unknown',
                                                    },
                                                  ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  )
                                  : ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: filteredCars.length,
                                    itemBuilder: (context, index) {
                                      final car = filteredCars[index];
                                      final data =
                                          car.data() as Map<String, dynamic>? ??
                                          {};
                                      return CarCard3D(
                                        model:
                                            data['model'] as String? ??
                                            'Unknown Model',
                                        price:
                                            (data['price'] as num?)
                                                ?.toDouble() ??
                                            0.0,
                                        imagePath:
                                            data['imagePath'] as String? ??
                                            'https://via.placeholder.com/300',
                                        carId: car.id,
                                        city:
                                            data['city'] as String? ??
                                            _filters['city'] as String? ??
                                            'Unknown',
                                        onBook: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => BookingScreen(
                                                    carId: car.id,
                                                    model:
                                                        data['model']
                                                            as String? ??
                                                        'Unknown',
                                                    car: {
                                                      'id': car.id,
                                                      'model':
                                                          data['model']
                                                              as String? ??
                                                          'Unknown',
                                                      'price':
                                                          data['price']
                                                              as num? ??
                                                          0.0,
                                                      'imagePath':
                                                          data['imagePath']
                                                              as String? ??
                                                          'https://via.placeholder.com/300',
                                                      'city':
                                                          data['city']
                                                              as String? ??
                                                          _filters['city']
                                                              as String? ??
                                                          'Unknown',
                                                    },
                                                  ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                await _firestoreService.seedCars(
                                  _filters['city'] as String? ?? 'Hyderabad',
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Cars seeded for ${_filters['city'] ?? 'Hyderabad'}!',
                                    ),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error seeding cars: $e'),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.amber.shade300,
                              padding: EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              'Refresh Car Data',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ).animate().fadeIn(duration: 400.ms),
                        SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
