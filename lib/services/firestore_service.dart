import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final CollectionReference cars = FirebaseFirestore.instance.collection(
    'cars',
  );
  final CollectionReference bookings = FirebaseFirestore.instance.collection(
    'bookings',
  );

  // Image URLs for seeding
  static const List<String> carImageUrls = [
    'https://images.unsplash.com/photo-1605557618244-929df0cb81e8?auto=compress',
    'https://images.unsplash.com/photo-1580273916550-ebdde4c6421b?auto=compress',
    'https://images.unsplash.com/photo-1606153607738-a28b36852d4b?auto=compress',
    'https://images.unsplash.com/photo-1626668893633-73e2e3b360c6?auto=compress',
    'https://images.unsplash.com/photo-1611653784679-0a2e2e9e4b1e?auto=compress',
    'https://images.unsplash.com/photo-1592805721367-98d6e678e6f8?auto=compress',
    'https://images.unsplash.com/photo-1605559423140-7e6c3f7f5931?auto=compress',
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
        'timestamp': FieldValue.serverTimestamp(),
      });
      if (kDebugMode) {
        print('Added car: $model in $city');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding car: $e');
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

  Future<void> bookCar({
    required String carId,
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  }) async {
    try {
      await bookings.add({
        'userId': userId,
        'carId': carId,
        'startDate': startDate,
        'endDate': endDate,
        'timestamp': FieldValue.serverTimestamp(),
      });
      await cars.doc(carId).update({'available': false});
      if (kDebugMode) {
        print('Booked car: $carId for user: $userId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error booking car: $e');
      }
      rethrow;
    }
  }

  Stream<QuerySnapshot> getUserBookings(String userId) {
    try {
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
      for (var i = 0; i < carData.length; i++) {
        final car = carData[i];
        await addCar(
          model: car['model'] as String,
          price: car['price'] as double,
          imagePath: carImageUrls[i % carImageUrls.length],
          available: true,
          city: city,
          carType: car['carType'] as String,
          condition: car['condition'] as String,
          fuel: car['fuel'] as String,
        );
      }
      if (kDebugMode) {
        print('Successfully seeded ${carData.length} cars for $city');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error seeding cars: $e');
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
      }
      rethrow;
    }
  }
}
