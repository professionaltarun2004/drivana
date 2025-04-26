// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/auth_provider.dart';
import '../services/firestore_service.dart';

class BookingScreen extends StatefulWidget {
  final String carId;
  final String? model;
  final Map<String, dynamic> car;

  const BookingScreen({
    super.key,
    required this.carId,
    this.model,
    required this.car,
  });

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? startDate;
  DateTime? endDate;
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  Future<void> _bookCar() async {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user == null) {
      setState(() {
        _errorMessage = 'Please log in to book a car.';
      });
      return;
    }
    if (startDate == null || endDate == null) {
      setState(() {
        _errorMessage = 'Please select both start and end dates.';
      });
      return;
    }
    if (endDate!.isBefore(startDate!)) {
      setState(() {
        _errorMessage = 'End date must be after start date.';
      });
      return;
    }
    setState(() => _isLoading = true);
    try {
      // Stripe Payment
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer sk_test_your_stripe_secret_key',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': (widget.car['price'] * 100).toString(),
          'currency': 'inr',
          'payment_method_types[]': 'card',
        },
      );
      final json = jsonDecode(response.body);
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: json['client_secret'],
          merchantDisplayName: 'Car Rental App',
        ),
      );
      await Stripe.instance.presentPaymentSheet();

      // Firestore Booking
      await FirestoreService().bookCar(
        carId: widget.carId,
        startDate: startDate!,
        endDate: endDate!,
        userId: user.uid,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking and payment confirmed for ${widget.model}!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = 'Booking or payment failed: ${e.toString()}';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book ${widget.model ?? 'Car'}',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: GoogleFonts.poppins(color: Colors.red),
              ).animate().shake(),
            SizedBox(height: 16),
            Text(
              'Select Rental Dates',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: 600.ms),
            SizedBox(height: 16),
            TextButton(
              onPressed: () => _selectDate(context, true),
              child: Text(
                startDate == null
                    ? 'Select Start Date'
                    : 'Start: ${DateFormat.yMd().format(startDate!)}',
                style: GoogleFonts.poppins(),
              ),
            ).animate().fadeIn(duration: 800.ms),
            SizedBox(height: 8),
            TextButton(
              onPressed: () => _selectDate(context, false),
              child: Text(
                endDate == null
                    ? 'Select End Date'
                    : 'End: ${DateFormat.yMd().format(endDate!)}',
                style: GoogleFonts.poppins(),
              ),
            ).animate().fadeIn(duration: 1000.ms),
            SizedBox(height: 16),
            Text(
              'Total: ₹${widget.car['price']}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.green.shade700,
              ),
            ).animate().fadeIn(duration: 1200.ms),
            Spacer(),
            ElevatedButton(
              onPressed:
                  (startDate != null && endDate != null && !_isLoading)
                      ? _bookCar
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity, 48),
              ),
              child:
                  _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                        'Pay and Confirm Booking',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ).animate().scale(duration: 500.ms),
          ],
        ),
      ),
    );
  }
}
