import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

class FilterScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onApply;

  FilterScreen({required this.onApply});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? _selectedCity;
  String? _selectedCarType;
  String? _selectedCondition;
  String? _selectedFuel;
  DateTime? _pickupDate;
  double _duration = 1.0;

  final List<Map<String, dynamic>> cities = [
    {'name': 'Agra', 'lat': 27.1767, 'lon': 78.0081},
    {'name': 'Ahmedabad', 'lat': 23.0225, 'lon': 72.5714},
    {'name': 'Ajmer', 'lat': 26.4499, 'lon': 74.6399},
    {'name': 'Alleppey', 'lat': 9.4981, 'lon': 76.3388},
    {'name': 'Amritsar', 'lat': 31.6340, 'lon': 74.8723},
    {'name': 'Hyderabad', 'lat': 17.3850, 'lon': 78.4867},
    // Add remaining 94 cities from April 19, 2025, 07:10 AM PDT response
  ];

  final List<String> carTypes = ['Sedan', 'SUV', 'Sports', 'Electric', 'Hatchback', 'MPV', 'Pickup'];
  final List<String> conditions = ['New', 'Used'];
  final List<String> fuels = ['Petrol', 'Diesel', 'Electric'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _pickupDate = picked;
      });
    }
  }

  void _applyFilters() {
    widget.onApply({
      'city': _selectedCity,
      'carType': _selectedCarType,
      'condition': _selectedCondition,
      'fuel': _selectedFuel,
      'pickupDate': _pickupDate,
      'duration': _duration.round(),
    });
    Navigator.pop(context);
  }

  void _selectCityFromTap(LatLng tappedPoint) {
    String? closestCity;
    double minDistance = double.infinity;

    for (var city in cities) {
      final cityPoint = LatLng(city['lat'], city['lon']);
      final distance = const Distance().as(
        LengthUnit.Kilometer,
        cityPoint,
        tappedPoint,
      );
      if (distance < minDistance && distance < 50) { // 50km threshold
        minDistance = distance;
        closestCity = city['name'];
      }
    }

    setState(() {
      _selectedCity = closestCity;
      print('Selected city: $closestCity, Distance: $minDistance km');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters', style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
        actions: [
          TextButton(
            onPressed: _applyFilters,
            child: Text(
              'Apply',
              style: GoogleFonts.poppins(color: Colors.amber.shade300),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select City on Map',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ).animate().fadeIn(duration: 400.ms),
              Container(
                height: 300,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(20.5937, 78.9629), // Center of India
                    initialZoom: 5.0,
                    onTap: (tapPosition, point) {
                      print('Map tapped at: $point');
                      _selectCityFromTap(point);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                      subdomains: ['a', 'b', 'c', 'd'],
                      tileProvider: NetworkTileProvider(),
                      retinaMode: RetinaMode.isHighDensity(context),
                      additionalOptions: {
                        'attribution': '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> © <a href="https://carto.com/attributions">CARTO</a>',
                      },
                    ),
                    MarkerLayer(
                      markers: cities.map((city) {
                        return Marker(
                          width: 80.0,
                          height: 80.0,
                          point: LatLng(city['lat'], city['lon']),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCity = city['name'];
                                print('Marker tapped: ${city['name']}');
                              });
                            },
                            child: Icon(
                              Icons.location_pin,
                              color: _selectedCity == city['name'] ? Colors.blue : Colors.red,
                              size: 40,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ).animate().slideY(begin: -0.1, duration: 400.ms),
              SizedBox(height: 16),
              Text(
                'Selected City: ${_selectedCity ?? 'None'}',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Car Type',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ).animate().fadeIn(duration: 400.ms),
              Wrap(
                spacing: 8.0,
                children: carTypes.map((type) {
                  return ChoiceChip(
                    label: Text(type, style: GoogleFonts.poppins()),
                    selected: _selectedCarType == type,
                    selectedColor: Colors.blue.shade700,
                    labelStyle: TextStyle(
                      color: _selectedCarType == type ? Colors.white : Colors.black,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedCarType = selected ? type : null;
                      });
                    },
                  );
                }).toList(),
              ).animate().slideX(begin: -0.1, duration: 400.ms),
              SizedBox(height: 16),
              Text(
                'Condition',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ).animate().fadeIn(duration: 400.ms),
              Wrap(
                spacing: 8.0,
                children: conditions.map((condition) {
                  return ChoiceChip(
                    label: Text(condition, style: GoogleFonts.poppins()),
                    selected: _selectedCondition == condition,
                    selectedColor: Colors.blue.shade700,
                    labelStyle: TextStyle(
                      color: _selectedCondition == condition ? Colors.white : Colors.black,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedCondition = selected ? condition : null;
                      });
                    },
                  );
                }).toList(),
              ).animate().slideX(begin: -0.1, duration: 400.ms),
              SizedBox(height: 16),
              Text(
                'Fuel Type',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ).animate().fadeIn(duration: 400.ms),
              Wrap(
                spacing: 8.0,
                children: fuels.map((fuel) {
                  return ChoiceChip(
                    label: Text(fuel, style: GoogleFonts.poppins()),
                    selected: _selectedFuel == fuel,
                    selectedColor: Colors.blue.shade700,
                    labelStyle: TextStyle(
                      color: _selectedFuel == fuel ? Colors.white : Colors.black,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedFuel = selected ? fuel : null;
                      });
                    },
                  );
                }).toList(),
              ).animate().slideX(begin: -0.1, duration: 400.ms),
              SizedBox(height: 16),
              Text(
                'Pickup Date',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ).animate().fadeIn(duration: 400.ms),
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  _pickupDate == null
                      ? 'Select Pickup Date'
                      : 'Pickup: ${DateFormat.yMd().format(_pickupDate!)}',
                  style: GoogleFonts.poppins(),
                ),
              ).animate().slideX(begin: -0.1, duration: 400.ms),
              SizedBox(height: 16),
              Text(
                'Duration (Days)',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ).animate().fadeIn(duration: 400.ms),
              Slider(
                value: _duration,
                min: 1,
                max: 30,
                divisions: 29,
                label: '${_duration.round()} days',
                activeColor: Colors.blue.shade700,
                onChanged: (value) {
                  setState(() {
                    _duration = value;
                  });
                },
              ).animate().slideX(begin: -0.1, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}