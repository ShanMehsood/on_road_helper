import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:road_helper/emergency/emergency_screen.dart';
import 'package:road_helper/mechanic/mechanic_screen.dart';
import 'package:road_helper/sale_person/sale_person.dart';
import '../services_seeker_detail/services_screen.dart';


class ServicesDetail extends StatefulWidget {


  const ServicesDetail({super.key});

  @override
  State<ServicesDetail> createState() => _ServicesDetailState();
}

class _ServicesDetailState extends State<ServicesDetail> {
  final Set<Marker> _markers = {};
  //private variable "_marker" use to hold all marker in the marker library in the googleMaps

  LatLng? _currentLocation;

  LatLng get currentLocation => _currentLocation!;

  GoogleMapController? _mapController;

  void _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Handle permission denied

      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    LatLng currentLocation = LatLng(position.latitude, position.longitude);
    _mapController?.animateCamera(CameraUpdate.newLatLng(currentLocation));
    setState(() {
      _currentLocation = position as LatLng?;
    });
    _markers.add(
      Marker(
        markerId: MarkerId('Current Location'),
        position:LatLng(_currentLocation!.latitude,_currentLocation!.longitude),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    // Update the map camera position
    _mapController?.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
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
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)),
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
            //padding: EdgeInsets.all(4.0),
            // height: 50,
            // width: 50,
            // Set the desired width of the InkWell button
            child: InkWellButton(
              icon: Icons.car_repair,
              //image: AssetImage('images/services.png'),
              text: 'Services  ',
              onTap: () {
                _getCurrentLocation();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ServiceScreen()));
              },
            ),
          ),
          SizedBox(height: 40),
          Container(
            // width: 50,
            // height: 50,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10),
            // ), // Set the desired width of the InkWell button
            child: InkWellButton(
              icon: Icons.handyman,

              // image: AssetImage('images/mechanic.png'),
              text: 'Mechanic',

              onTap: () {
                _getCurrentLocation();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MechanicScreen()));
              },
            ),
          ),
          SizedBox(height: 40),
          Container(
            // width: 50,
            // height: 50, // Set the desired width of the InkWell button
            child: InkWellButton(
              icon: Icons.shop_two,

              //image: AssetImage('images/Saleperson.png'),
              text: 'Sale Person',
              onTap: () {
                _getCurrentLocation();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SalePerson()));
              },
            ),
          ),
          SizedBox(height: 40),
          Container(
            width: 30,
            height: 50, // Set the desired width of the InkWell button
            child: InkWellButton(
              icon: Icons.emergency_rounded,
              //image: AssetImage('images/emergency.png'),
              text: 'Emergency',
              onTap: () {
                _getCurrentLocation();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EmergencyScreen()));
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
             width: 50,
            height: 50,
           decoration: BoxDecoration(
             color: Colors.deepOrange,
           border: Border.all(color: Colors.white),
             borderRadius: BorderRadius.circular(40),
        ),

        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             // Image(
                //image: image,),
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