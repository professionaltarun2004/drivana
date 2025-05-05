import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Added for authentication check

class FirestoreService {
  final CollectionReference cars = FirebaseFirestore.instance.collection(
    'cars',
  );
  final CollectionReference bookings = FirebaseFirestore.instance.collection(
    'bookings',
  );

  // Use local assets as a fallback for images
  // static const List<String> carImageUrls = [
  //   'D:\\B-Tech\\Internships\\Pianalytix\\Apps\\drivana\assets\\images\\car1.jpg', // Replace with actual asset paths
  //   'D:\\B-TechInternships\\Pianalytix\\Apps\\assets\\images\\car2.jpg',
  //   'D:\\B-Tech\\Internships\\Apps\\drivana\\assets\\images\\car3.jpg',
  //   'D:\\B-Tech\\Internships\\Pianalytix\\Apps\\drivana\\assets\\images\\car4.jpg',
  //   'D:\\B-Tech\\Internships\\Pianalytix\\Apps\\drivana\\assets\\images\\car5.jpg',
  //   'D:\\B-Tech\\Internships\\Pianalytix\\Apps\\drivana\\assets\\images\\car6.jpg',
  //   'D:\\B-Tech\\Internships\\Pianalytix\\Apps\\drivana\\assets\\images\\car7.jpg',
  // ];
  static const List<String> carImageUrls = [
    'assets/images/car1.jpg',
    'assets/images/car2.jpg',
    'assets/images/car3.jpg',
    'assets/images/car4.jpg',
    'assets/images/car5.jpg',
    'assets/images/car6.jpg',
    'assets/images/car7.jpg',
  ];

  // Fallback to online URLs if network is available (optional)
  static const List<String> onlineCarImageUrls = [
    "https://images.unsplash.com/photo-1459603677915-a62079ffd002?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Y2FyfGVufDB8fDB8fHww",
    'https://images.unsplash.com/photo-1502877338535-766e1452684a?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fGNhcnxlbnwwfHwwfHx8MA%3D%3D',
    'https://images.unsplash.com/photo-1507136566006-cfc505b114fc?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzZ8fGNhcnxlbnwwfHwwfHx8MA%3D%3D',
    'https://images.unsplash.com/photo-1603584173870-7f23fdae1b7a?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mzl8fGNhcnxlbnwwfHwwfHx8MA%3D%3D',
    'https://images.unsplash.com/photo-1542362567-b07e54358753?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDl8fGNhcnxlbnwwfHwwfHx8MA%3D%3D',
    'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTh8fGNhcnxlbnwwfHwwfHx8MA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1683121316206-8441783ee61f?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTA0fHxjYXJ8ZW58MHx8MHx8fDA%3D',
  ];

  // Static location data for seeding (around Hyderabad)
  static const List<Map<String, double>> carLocations = [
    {'latitude': 17.395044, 'longitude': 78.496671}, // 1 km NE of Hyderabad
    {'latitude': 17.375044, 'longitude': 78.476671}, // 1 km SW
    {'latitude': 17.365044, 'longitude': 78.466671}, // 2 km SW
    {'latitude': 17.405044, 'longitude': 78.486671}, // 1 km N
    {'latitude': 17.385044, 'longitude': 78.506671}, // 1 km E
    {'latitude': 17.375044, 'longitude': 78.496671}, // 1 km S
    {'latitude': 17.395044, 'longitude': 78.466671}, // 1 km W
  ];

  Future<void> addCar({
    required String model,
    required double price,
    required String imagePath,
    required bool available,
    required String city,
    required String carType,
    required String condition,
    required String fuel,
    double? latitude,
    double? longitude,
  }) async {
    try {
      await cars.add({
        'model': model,
        'price': price,
        'imagePath': imagePath,
        'available': available,
        'city': city,
        'carType': carType,
        'condition': condition,
        'fuel': fuel,
        'latitude': latitude ?? carLocations[0]['latitude'],
        'longitude': longitude ?? carLocations[0]['longitude'],
        'timestamp': FieldValue.serverTimestamp(),
      });
      if (kDebugMode) {
        print('Added car: $model in $city at ($latitude, $longitude)');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding car: $e');
        if (e.toString().contains('permission-denied')) {
          print(
            'Permission denied: Check Firestore rules for /cars collection.',
          );
        } else if (e.toString().contains('network')) {
          print(
            'Network error: Unable to connect to Firestore. Check internet connection.',
          );
        }
      }
      rethrow;
    }
  }

  Stream<QuerySnapshot> getCars({
    String? city,
    String? carType,
    String? condition,
    String? fuel,
    DateTime? pickupDate,
    int? duration,
  }) {
    try {
      Query query = cars.where('available', isEqualTo: true);
      if (city != null && city.isNotEmpty) {
        query = query.where('city', isEqualTo: city);
      }
      if (carType != null && carType.isNotEmpty) {
        query = query.where('carType', isEqualTo: carType);
      }
      if (condition != null && condition.isNotEmpty) {
        query = query.where('condition', isEqualTo: condition);
      }
      if (fuel != null && fuel.isNotEmpty) {
        query = query.where('fuel', isEqualTo: fuel);
      }
      if (kDebugMode) {
        print(
          'Fetching cars with filters: city=$city, carType=$carType, condition=$condition, fuel=$fuel',
        );
      }
      return query.snapshots();
    } catch (e) {
      if (kDebugMode) {
        print('Error building query: $e');
      }
      rethrow;
    }
  }

  Future<DocumentReference> bookCar({
    required String carId,
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  }) async {
    try {
      // Check if user is authenticated
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User must be authenticated to book a car.');
      }
      if (user.uid != userId) {
        throw Exception('User ID does not match authenticated user.');
      }

      DocumentReference bookingRef = await bookings.add({
        'userId': userId,
        'carId': carId,
        'startDate': startDate,
        'endDate': endDate,
        'timestamp': FieldValue.serverTimestamp(),
      });
      await cars.doc(carId).update({'available': false});
      if (kDebugMode) {
        print(
          'Booked car: $carId for user: $userId with booking ID: ${bookingRef.id}',
        );
      }
      return bookingRef;
    } catch (e) {
      if (kDebugMode) {
        print('Error booking car: $e');
        if (e.toString().contains('permission-denied')) {
          print('Permission denied: User must be authenticated to book a car.');
        }
      }
      rethrow;
    }
  }

  Stream<QuerySnapshot> getUserBookings(String userId) {
    try {
      // Check if user is authenticated
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User must be authenticated to fetch bookings.');
      }
      if (user.uid != userId) {
        throw Exception('User ID does not match authenticated user.');
      }

      return bookings.where('userId', isEqualTo: userId).snapshots();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching bookings: $e');
      }
      rethrow;
    }
  }

  Future<void> seedCars(String city) async {
    final carData = [
      {
        'model': 'Honda Civic',
        'price': 45.0,
        'carType': 'Sedan',
        'condition': 'Used',
        'fuel': 'Petrol',
      },
      {
        'model': 'Toyota Innova',
        'price': 60.0,
        'carType': 'SUV',
        'condition': 'New',
        'fuel': 'Diesel',
      },
      {
        'model': 'Maruti Suzuki Brezza',
        'price': 50.0,
        'carType': 'SUV',
        'condition': 'New',
        'fuel': 'Petrol',
      },
      {
        'model': 'Hyundai Venue',
        'price': 55.0,
        'carType': 'SUV',
        'condition': 'Used',
        'fuel': 'Petrol',
      },
      {
        'model': 'Mahindra Thar',
        'price': 70.0,
        'carType': 'SUV',
        'condition': 'New',
        'fuel': 'Diesel',
      },
      {
        'model': 'Tata Nexon',
        'price': 48.0,
        'carType': 'SUV',
        'condition': 'New',
        'fuel': 'Electric',
      },
      {
        'model': 'Kia Seltos',
        'price': 65.0,
        'carType': 'SUV',
        'condition': 'New',
        'fuel': 'Petrol',
      },
    ];

    try {
      // Check if seeding is necessary
      final existingCars = await cars.where('city', isEqualTo: city).get();
      if (existingCars.docs.isNotEmpty) {
        if (kDebugMode) {
          print('Cars already exist for $city. Skipping seeding.');
        }
        return; // Skip seeding if cars already exist
      }

      // Clear existing cars (if any) and seed new ones
      for (var doc in existingCars.docs) {
        await doc.reference.delete();
      }
      if (kDebugMode) {
        print('Cleared existing cars for $city before seeding.');
      }

      for (var i = 0; i < carData.length; i++) {
        final car = carData[i];
        final location = carLocations[i % carLocations.length];
        await addCar(
          model: car['model'] as String,
          price: car['price'] as double,
          imagePath: carImageUrls[i % carImageUrls.length],
          available: true,
          city: city,
          carType: car['carType'] as String,
          condition: car['condition'] as String,
          fuel: car['fuel'] as String,
          latitude: location['latitude'],
          longitude: location['longitude'],
        );
      }
      if (kDebugMode) {
        print('Successfully seeded ${carData.length} cars for $city');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error seeding cars: $e');
        if (e.toString().contains('permission-denied')) {
          print(
            'Permission denied: Check Firestore rules for /cars collection.',
          );
        }
      }
      rethrow;
    }
  }

  Future<void> checkAndSeedCars(String city) async {
    try {
      final snapshot = await cars.where('city', isEqualTo: city).limit(1).get();
      if (snapshot.docs.isEmpty) {
        if (kDebugMode) {
          print('No cars found for $city, seeding...');
        }
        await seedCars(city);
      } else {
        if (kDebugMode) {
          print('Cars already exist for $city');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking cars: $e');
        if (e.toString().contains('network')) {
          print(
            'Network error: Unable to connect to Firestore. Check internet connection.',
          );
        }
      }
      rethrow;
    }
  }
}
