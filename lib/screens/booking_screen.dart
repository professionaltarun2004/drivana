import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BookingScreen extends StatefulWidget {
  final String carId;
  final String? model;

  const BookingScreen({super.key, required this.carId, this.model});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? startDate;
  DateTime? endDate;
  String? _errorMessage;

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
    try {
      await FirestoreService().bookCar(
        carId: widget.carId,
        startDate: startDate!,
        endDate: endDate!,
        userId: user.uid,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking confirmed for ${widget.model}!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = 'Booking failed: ${e.toString()}';
      });
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
          children: [
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: GoogleFonts.poppins(color: Colors.red),
              ).animate().shake(),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => _selectDate(context, true),
              child: Text(
                startDate == null
                    ? 'Select Start Date'
                    : 'Start: ${DateFormat.yMd().format(startDate!)}',
                style: GoogleFonts.poppins(),
              ),
            ).animate().fadeIn(duration: 500.ms),
            TextButton(
              onPressed: () => _selectDate(context, false),
              child: Text(
                endDate == null
                    ? 'Select End Date'
                    : 'End: ${DateFormat.yMd().format(endDate!)}',
                style: GoogleFonts.poppins(),
              ),
            ).animate().fadeIn(duration: 600.ms),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _bookCar,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.blue.shade700,
              ),
              child: Text(
                'Confirm Booking',
                style: GoogleFonts.poppins(
                  color: Colors.white,
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
