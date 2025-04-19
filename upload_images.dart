import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final storage = FirebaseStorage.instance;
  final images = [
    {'path': 'kaggle_data/car_images/BMW/001.jpg', 'name': 'bmw_sedan.jpg'},
    {'path': 'kaggle_data/car_images/Toyota/002.jpg', 'name': 'toyota_suv.jpg'},
    {
      'path': 'kaggle_data/car_images/Tesla/003.jpg',
      'name': 'tesla_model_s.jpg',
    },
    {
      'path': 'kaggle_data/car_images/Porsche/004.jpg',
      'name': 'porsche_911.jpg',
    },
    {'path': 'kaggle_data/car_images/Honda/005.jpg', 'name': 'honda_civic.jpg'},
  ];

  for (var image in images) {
    final file = File(image['path']!);
    if (file.existsSync()) {
      final ref = storage.ref('cars/${image['name']}');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      if (kDebugMode) {
        print('Uploaded ${image['name']}: $url');
      }
    } else {
      if (kDebugMode) {
        print('File not found: ${image['path']}');
      }
    }
  }
}
