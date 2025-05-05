import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart'
    as osm; // Alias for OSM
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Default GeoPoint for Firestore

class TrackingScreen extends StatefulWidget {
  final String bookingId; // Pass the booking ID to fetch car details

  const TrackingScreen({Key? key, required this.bookingId}) : super(key: key);

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  osm.MapController? mapController; // Use osm prefix for MapController
  Location location = Location();
  GeoPoint? userLocation; // Firestore GeoPoint for user location
  GeoPoint? bookedCarLocation; // Firestore GeoPoint for booked car
  List<GeoPoint> nearbyCars = []; // Firestore GeoPoint for nearby cars
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    mapController = osm.MapController(
      initMapWithUserPosition: const osm.UserTrackingOption(
        enableTracking: true,
        unFollowUser: false,
      ),
      initPosition: osm.GeoPoint(
        latitude: 17.385044,
        longitude: 78.486671,
      ), // OSM GeoPoint as default
    );
    _initializeLocationAndMap();
  }

  Future<void> _initializeLocationAndMap() async {
    // Request location permission
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // Get user location
    LocationData locationData = await location.getLocation();
    GeoPoint? userLocation = GeoPoint(
      locationData.latitude ?? 17.385044,
      locationData.longitude ?? 78.486671,
    );

    // Fetch booking details from Firestore
    try {
      DocumentSnapshot bookingDoc =
          await FirebaseFirestore.instance
              .collection('bookings')
              .doc(widget.bookingId)
              .get();
      if (!bookingDoc.exists) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Booking not found')));
        return;
      }

      String carId = bookingDoc['carId'];

      // Fetch booked car's location
      try {
        DocumentSnapshot carDoc =
            await FirebaseFirestore.instance.collection('cars').doc(carId).get();
        if (carDoc.exists) {
          var carData = carDoc.data() as Map<String, dynamic>;
          bookedCarLocation = GeoPoint(carData['latitude'], carData['longitude']);
        } else {
          // Fallback to mock location if car not found
          bookedCarLocation = GeoPoint(17.395044, 78.496671);
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error fetching car location')));
        return;
      }

      // Convert Firestore GeoPoint to OSM GeoPoint for map marker
      await mapController!.addMarker(
        osm.GeoPoint(
          latitude: bookedCarLocation!.latitude,
          longitude: bookedCarLocation!.longitude,
        ),
        markerIcon: const osm.MarkerIcon(
          icon: Icon(Icons.car_rental, color: Colors.blue, size: 40),
        ),
      );

      // Fetch nearby cars from Firestore
      try {
        QuerySnapshot carsSnapshot =
            await FirebaseFirestore.instance
                .collection('cars')
                .where('city', isEqualTo: 'Hyderabad')
                .where('available', isEqualTo: true)
                .get();

        nearbyCars.clear();
        for (var doc in carsSnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          nearbyCars.add(GeoPoint(data['latitude'], data['longitude']));
        }

        // Add nearby cars to map (convert to OSM GeoPoint)
        for (var car in nearbyCars) {
          await mapController!.addMarker(
            osm.GeoPoint(latitude: car.latitude, longitude: car.longitude),
            markerIcon: const osm.MarkerIcon(
              icon: Icon(Icons.car_rental, color: Colors.red, size: 30),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error fetching nearby cars')));
        return;
      }

      // Draw a route (convert Firestore GeoPoints to OSM GeoPoints)
      if (userLocation != null && bookedCarLocation != null) {
        await mapController!.drawRoad(
          osm.GeoPoint(
            latitude: userLocation.latitude,
            longitude: userLocation.longitude,
          ),
          osm.GeoPoint(
            latitude: bookedCarLocation!.latitude,
            longitude: bookedCarLocation!.longitude,
          ),
          roadType: osm.RoadType.car,
          roadOption: const osm.RoadOption(roadColor: Colors.blue, roadWidth: 5),
        );
      }

      setState(() {
        _isLoading = false;
      });

      // Listen for real-time updates to the car's location
      _listenToCarLocation(carId);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error fetching booking details')));
      return;
    }
  }

  void _listenToCarLocation(String carId) {
    FirebaseFirestore.instance.collection('cars').doc(carId).snapshots().listen(
      (snapshot) {
        if (snapshot.exists) {
          var data = snapshot.data() as Map<String, dynamic>;
          if (data.containsKey('latitude') && data.containsKey('longitude')) {
            setState(() {
              bookedCarLocation = GeoPoint(data['latitude'], data['longitude']);
            });
            mapController!.changeLocationMarker(
              oldLocation: osm.GeoPoint(
                latitude: bookedCarLocation!.latitude,
                longitude: bookedCarLocation!.longitude,
              ),
              newLocation: osm.GeoPoint(
                latitude: bookedCarLocation!.latitude,
                longitude: bookedCarLocation!.longitude,
              ),
              markerIcon: const osm.MarkerIcon(
                icon: Icon(Icons.car_rental, color: Colors.blue, size: 40),
              ),
            );
          }
        }
      },
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track Your Car')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : osm.OSMFlutter(
                controller: mapController!,
                osmOption: osm.OSMOption(
                  userTrackingOption: const osm.UserTrackingOption(
                    enableTracking: true,
                    unFollowUser: false,
                  ),
                  zoomOption: const osm.ZoomOption(
                    initZoom: 15,
                    minZoomLevel: 10,
                    maxZoomLevel: 19,
                  ),
                  userLocationMarker: osm.UserLocationMaker(
                    personMarker: const osm.MarkerIcon(
                      icon: Icon(
                        Icons.location_pin,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),
                    directionArrowMarker: const osm.MarkerIcon(
                      icon: Icon(
                        Icons.navigation,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Recenter map on user location
          if (userLocation != null) {
            await mapController!.setZoom(zoomLevel: 15);
            await mapController!.moveTo(
              osm.GeoPoint(
                latitude: userLocation!.latitude,
                longitude: userLocation!.longitude,
              ),
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
