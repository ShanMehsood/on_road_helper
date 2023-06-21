import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Person {
  final String name;
  final String phoneNumber;
  final LatLng position;

  Person({
    required this.name,
    required this.phoneNumber,
    required this.position,
  });
}

class SalePerson extends StatefulWidget {
  const SalePerson({Key? key}) : super(key: key);

  @override
  _SalePersonState createState() => _SalePersonState();
}

class _SalePersonState extends State<SalePerson> {
  LocationFetchingMessage _isLoadingMessage = LocationFetchingMessage('');
  final Set<Marker> _markers = {};
  bool _isLoading = true;
  bool _permissionDenied = false;

  LatLng? _initialPosition;

  final List<Person> _people = [
    Person(
      name: 'Name: Adnan',
      phoneNumber: '03045117926',
      position: LatLng(34.00771305752101, 71.49328082698405),
    ),
    Person(
      name: 'Name: Zeeshan',
      phoneNumber: '03159507647',
      position: LatLng(33.997732000140694, 71.4890765296722),
    ),
    Person(
      name: 'Name: Abdullah',
      phoneNumber: '03049798799',
      position: LatLng(34.028273034466665, 71.47572845118844),
    ),
    Person(
      name: 'Name: Waseem Ikram',
      phoneNumber: '031390989491',
      position: LatLng(34.0361328859879, 71.47860377922923),
    ),
    Person(
      name: 'Name: Bilal',
      phoneNumber: '03170687437',
      position: LatLng(34.02517868503597, 71.476758419437),
    ),
    Person(
      name: 'Name: Rashid',
      phoneNumber: '03189515744',
      position: LatLng(34.030407002775256, 71.48465484275701),
    ),
    Person(
      name: 'Name: Ali',
      phoneNumber: '03263162413',
      position: LatLng(34.02012789533262, 71.49722903862093),
    ),
    // Add more people with their names, phone numbers, and positions
  ];

  GoogleMapController? _mapController;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Sale Person')),
        backgroundColor: Colors.deepOrange,
      ),
      body: Stack(
        children: [
          _isLoading
              ? Center(
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: LoadingIndicator(
                indicatorType: Indicator.ballPulse,
                colors: [Colors.black],
              ),
            ),
          )
              : _permissionDenied
              ? const Center(
            child: Text('Location permission denied.'),
          )
              : GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
              _setMarkers();
            },
            initialCameraPosition: CameraPosition(
              target: _initialPosition ?? LatLng(0, 0),
              zoom: 14,
            ),
            markers: _markers,
          ),
          if (_isLoading || _isLoadingMessage.message.isNotEmpty)
            Container(
              color: Colors.white.withOpacity(0.8),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoading)
                      SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballPulse,
                          colors: [Colors.black],
                        ),
                      ),
                    if (_isLoading && _isLoadingMessage.message.isNotEmpty)
                      SizedBox(height: 10),
                    if (_isLoadingMessage.message.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          _isLoadingMessage.message,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _setMarkers() async {
    if (_currentPosition != null) {
      final LatLng currentPositionLatLng = LatLng(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)),
        'images/result.png',
      );

      _markers.add(
        Marker(
          markerId: const MarkerId('Current Location'),
          position: currentPositionLatLng,
          icon: icon,
        ),
      );
    }

    for (Person person in _people) {
      BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)),
        'images/saleshop.png',
      );

      _markers.add(
        Marker(
          markerId: MarkerId(person.name),
          position: person.position,
          icon: icon,
          onTap: () {
            final double distance = DistanceCalculator.calculateDistance(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              person.position.latitude,
              person.position.longitude,
            );
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Stack(
                  children: [
                    Positioned(
                      bottom: 10,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                          color: Colors.grey,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 70),
                            Text(
                              person.name,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              'Distance: ${distance.toStringAsFixed(2)} Km',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 30),
                            GestureDetector(
                              onTap: () {
                                _makePhoneCall(person.phoneNumber);
                              },
                              child: Text(
                                'Contact: ${person.phoneNumber}',
                                style: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      );
    }

    setState(() {}); // Update the markers on the map
  }

  void _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _isLoadingMessage = LocationFetchingMessage('Wait, fetching your current location...');
    });

    final Position? position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).catchError((error) {
      debugPrint(error.toString());
      setState(() {
        _isLoadingMessage = LocationFetchingMessage('Failed to fetch current location.');
      });
    });

    setState(() {
      _isLoading = false;
      _isLoadingMessage = LocationFetchingMessage('');
      if (position != null) {
        _currentPosition = position;
        _initialPosition = LatLng(position.latitude, position.longitude);
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _initialPosition!,
              zoom: 14,
            ),
          ),
        );
        _setMarkers();
      } else {
        _permissionDenied = true;
      }
    });
  }


  void _makePhoneCall(String phoneNumber) async {
    await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }
}

class DistanceCalculator {
  static double calculateDistance(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,
      ) {
    const int earthRadius = 6371; // in kilometers

    final double latDiff = _degreesToRadians(endLatitude - startLatitude);
    final double lonDiff = _degreesToRadians(endLongitude - startLongitude);

    final double a = pow(sin(latDiff / 2), 2) +
        cos(_degreesToRadians(startLatitude)) *
            cos(_degreesToRadians(endLatitude)) *
            pow(sin(lonDiff / 2), 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    final double distance = earthRadius * c;
    return distance;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}

class LocationFetchingMessage {
  final String message;

  LocationFetchingMessage(this.message);
}