import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/car_details_screen.dart';

class CarCard extends StatelessWidget {
  final String? model;
  final double? price;
  final String? imageUrl;

  const CarCard({super.key, this.model = 'Toyota Camry', this.price = 50.0, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: imageUrl != null
            ? Image.network(imageUrl!, width: 50, height: 50)
            : Image.asset('assets/images/placeholder_car.jpg', width: 50, height: 50),
        title: Text(model!, style: GoogleFonts.poppins()),
        subtitle: Text('\$${price!.toStringAsFixed(2)}/day'),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarDetailsScreen(model: model, price: price, imageUrl: imageUrl),
            ),
          );
        },
      ),
    );
  }
}