import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference cars = FirebaseFirestore.instance.collection(
    'cars',
  );
  final CollectionReference bookings = FirebaseFirestore.instance.collection(
    'bookings',
  );

  Future<void> addCar(String model, double price, String imageUrl) async {
    await cars.add({
      'model': model,
      'price': price,
      'image_url': imageUrl,
      'available': true,
    });
  }

  Stream<QuerySnapshot> getCars() {
    return cars.snapshots();
  }

  Future<void> bookCar(
    String carId,
    DateTime startDate,
    DateTime endDate,
    String userId,
  ) async {
    await bookings.add({
      'user_id': userId,
      'car_id': carId,
      'start_date': startDate,
      'end_date': endDate,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
