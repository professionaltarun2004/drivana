// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FilterScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;
  final Map<String, dynamic> initialFilters;

  const FilterScreen({
    super.key,
    required this.onApplyFilters,
    this.initialFilters = const {'city': 'Hyderabad'},
  });

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late String _city;
  String? _carType;
  String? _condition;
  String? _fuel;
  DateTime? _pickupDate;
  int? _duration;

  final List<String> _cities = [
    'Hyderabad',
    'Bangalore',
    'Chennai',
    'Mumbai',
    'Delhi',
  ];
  final List<String> _carTypes = ['SUV', 'Sedan', 'Hatchback', 'Luxury'];
  final List<String> _conditions = ['New', 'Used'];
  final List<String> _fuels = ['Petrol', 'Diesel', 'Electric'];

  @override
  void initState() {
    super.initState();
    _city = widget.initialFilters['city'] ?? 'Hyderabad';
    _carType = widget.initialFilters['carType'];
    _condition = widget.initialFilters['condition'];
    _fuel = widget.initialFilters['fuel'];
    _pickupDate = widget.initialFilters['pickupDate'];
    _duration = widget.initialFilters['duration'];
  }

  void _applyFilters() {
    final filters = {
      'city': _city,
      'carType': _carType,
      'condition': _condition,
      'fuel': _fuel,
      'pickupDate': _pickupDate,
      'duration': _duration,
    };
    widget.onApplyFilters(filters);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Filter Cars',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
            ),
            DropdownButtonFormField<String>(
              value: _city,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items:
                  _cities.map((city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city, style: GoogleFonts.poppins()),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _city = value!;
                });
              },
            ).animate().fadeIn(duration: 600.ms),
            SizedBox(height: 16),
            Text(
              'Car Type',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
            ),
            DropdownButtonFormField<String>(
              value: _carType,
              hint: Text(
                'Select Car Type',
                style: GoogleFonts.poppins(color: Colors.grey.shade600),
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items:
                  _carTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type, style: GoogleFonts.poppins()),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _carType = value;
                });
              },
            ).animate().fadeIn(duration: 600.ms),
            SizedBox(height: 16),
            Text(
              'Condition',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
            ),
            DropdownButtonFormField<String>(
              value: _condition,
              hint: Text(
                'Select Condition',
                style: GoogleFonts.poppins(color: Colors.grey.shade600),
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items:
                  _conditions.map((condition) {
                    return DropdownMenuItem<String>(
                      value: condition,
                      child: Text(condition, style: GoogleFonts.poppins()),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _condition = value;
                });
              },
            ).animate().fadeIn(duration: 600.ms),
            SizedBox(height: 16),
            Text(
              'Fuel Type',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
            ),
            DropdownButtonFormField<String>(
              value: _fuel,
              hint: Text(
                'Select Fuel Type',
                style: GoogleFonts.poppins(color: Colors.grey.shade600),
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items:
                  _fuels.map((fuel) {
                    return DropdownMenuItem<String>(
                      value: fuel,
                      child: Text(fuel, style: GoogleFonts.poppins()),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _fuel = value;
                });
              },
            ).animate().fadeIn(duration: 600.ms),
            SizedBox(height: 16),
            Text(
              'Pickup Date',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: Icon(
                  Icons.calendar_today,
                  color: Colors.blue.shade700,
                ),
              ),
              readOnly: true,
              controller: TextEditingController(
                text:
                    _pickupDate != null
                        ? DateFormat('yyyy-MM-dd').format(_pickupDate!)
                        : '',
              ),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _pickupDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (picked != null && picked != _pickupDate) {
                  setState(() {
                    _pickupDate = picked;
                  });
                }
              },
            ).animate().fadeIn(duration: 600.ms),
            SizedBox(height: 16),
            Text(
              'Duration (Days)',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Enter duration',
              ),
              keyboardType: TextInputType.number,
              controller: TextEditingController(
                text: _duration?.toString() ?? '',
              ),
              onChanged: (value) {
                setState(() {
                  _duration = int.tryParse(value) ?? 0;
                });
              },
            ).animate().fadeIn(duration: 600.ms),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.amber.shade300,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Apply Filters',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ).animate().fadeIn(duration: 600.ms),
            ),
          ],
        ),
      ),
    );
  }
}
