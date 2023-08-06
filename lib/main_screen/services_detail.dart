import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:road_helper/emergency/emergency_screen.dart';
import 'package:road_helper/sale_person/sale_person.dart';
import '../mechanic/mechani_screen.dart';
import '../services_seeker_detail/services_screen.dart';


class ServicesDetail extends StatefulWidget {


  const ServicesDetail({super.key});

  @override
  State<ServicesDetail> createState() => _ServicesDetailState();
}

class _ServicesDetailState extends State<ServicesDetail> {
  final databaseRef = FirebaseDatabase.instance.ref('History');
  // This line creates a reference to the History
  // node in the Realtime Database.
  //The History node appears to be the parent node
  // where service-related data is stored.

  final Set<Marker> _markers = {};
  LatLng? _currentLocation;
  GoogleMapController? _mapController;
  late String childKey; // Define the childKey variable

  void _getCurrentLocation(String childKey) async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      // Handle permission denied
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    LatLng currentLocation = LatLng(position.latitude, position.longitude);
    _mapController?.animateCamera(CameraUpdate.newLatLng(currentLocation));
    setState(() {
      _currentLocation = currentLocation;
    });
    _markers.add(
      Marker(
        markerId: MarkerId('Current Location'),
        position: currentLocation,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    _mapController?.animateCamera(CameraUpdate.newLatLng(_currentLocation!));

    if (_currentLocation != null) {
      DatabaseReference childRef = databaseRef.child('ServiceHistory').child(childKey); // Modify the child reference to include childKey

      childRef.push().set({
        'latitude': _currentLocation!.latitude,
        'longitude': _currentLocation!.longitude,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Center(child: Text('Services Details')),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 10),
          Container(
            height: 250,
            // width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'images/logoroadhelper.png',
                  width: 200,
                  height: 200,
                ),
              ],
            ),
          ),
          SizedBox(height: 60),
          Container(
            child: InkWellButton(
              icon: Icons.car_repair,
              text: 'Services  ',
              onTap: () {
                childKey = "1";
                _getCurrentLocation(childKey);
                //After setting the childKey, the _getCurrentLocation
                // function is called with the childKey as an argument.
                // This function retrieves the current device location and stores
                // it in the Realtime Database under the appropriate service type.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ServiceScreen()),
                );
              },
            ),
          ),
          SizedBox(height: 40),
          Container(
            child: InkWellButton(
              icon: Icons.handyman,
              text: 'Mechanic',
              onTap: () {
                childKey = "2";
                _getCurrentLocation(childKey);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MechanicScreen()),
                );
              },
            ),
          ),
          SizedBox(height: 40),
          Container(
            child: InkWellButton(
              icon: Icons.shop_two,
              text: 'Sale Person',
              onTap: () {
                childKey = "3";
                _getCurrentLocation(childKey);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SalePerson()),
                );
              },
            ),
          ),
          SizedBox(height: 40),
          Container(

            child: InkWellButton(
              icon: Icons.emergency_rounded,
              text: 'Emergency',
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmergencyScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class InkWellButton extends StatelessWidget {
  //final ImageProvider image;
  final String text;
  final VoidCallback onTap;
  final IconData icon;

  InkWellButton({
   // required this.image,
    required this.text,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
       return InkWell(
          onTap: onTap,
           child: Container(
             height: 50,
             decoration: BoxDecoration(
               color: Colors.deepOrange,
               border: Border.all(color: Colors.white),
               borderRadius: BorderRadius.circular(40),
             ),
             child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   SizedBox(width: 10),
                   Center(
                     child: Text(
                    text,
                    style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),
              SizedBox(width: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Center(
                  child: Icon(
                    icon,
                    size: 50.0,
                  ),
                ),
              )
            ]
        ),
      ),
    );
  }
}