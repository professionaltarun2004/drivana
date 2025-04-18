// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/firestore_service.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    return Scaffold(
      appBar: AppBar(title: Text('Book ${widget.model ?? 'Car'}')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextButton(
              onPressed: () => _selectDate(context, true),
              child: Text(startDate == null
                  ? 'Select Start Date'
                  : 'Start: ${DateFormat.yMd().format(startDate!)}'),
            ),
            TextButton(
              onPressed: () => _selectDate(context, false),
              child: Text(endDate == null
                  ? 'Select End Date'
                  : 'End: ${DateFormat.yMd().format(endDate!)}'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: startDate != null && endDate != null && user != null
                  ? () async {
                      await FirestoreService().bookCar(widget.carId, startDate!, endDate!, user.uid);
                      Navigator.pop(context);
                    }
                  : null,
              child: Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}