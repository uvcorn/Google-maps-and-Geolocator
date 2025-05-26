import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GoogleMapController _mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition: CameraPosition(
          zoom: 19,
          target: LatLng(23.54398213486613, 89.17913657413058),
        ),
        compassEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        onLongPress: (LatLng lating) {
          print(lating);
        },
        onTap: (LatLng lating) {
          print(lating);
        },
        markers: {
          Marker(
            markerId: MarkerId('g-maps'),
            position: LatLng(23.544000859071215, 89.17918161125861),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
            onTap: () {
              // print('object');
            },
            infoWindow: InfoWindow(title: '57ew1'),
          ),
          Marker(
            markerId: MarkerId('g-map'),
            position: LatLng(23.54375680978106, 89.1790932007921),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
            onTap: () {
              // print('object');
            },
            draggable: true,
            onDrag: (LatLng lating) {},
            infoWindow: InfoWindow(title: '57ew1'),
          ),
        },
        polylines: {
          Polyline(
            polylineId: PolylineId('StraightLine'),
            color: Colors.red,
            endCap: Cap.roundCap,
            startCap: Cap.roundCap,
            jointType: JointType.round,
            points: [
              LatLng(23.54395455873987, 89.17865999042988),
              LatLng(23.543778745443053, 89.17928025126457),
              LatLng(23.544092258500505, 89.17955048382282),
            ],
          ),
        },
        circles: {
          Circle(
            circleId: CircleId('virus'),
            center: LatLng(23.5444503386762, 89.17912133038044),
            radius: 15,
            strokeWidth: 2,
            strokeColor: Colors.red,

            fillColor: Colors.red.withValues(alpha: 0.3),
          ),
        },
        polygons: {
          Polygon(
            polygonId: PolygonId('polygon'),
            points: [
              LatLng(23.543687150310657, 89.17923331260681),
              LatLng(23.543616456037356, 89.17937379330397),

              LatLng(23.54347598947715, 89.17937513440847),
              LatLng(23.543422200273223, 89.17925409972668),
              LatLng(23.543471686341647, 89.17912501841784),
              LatLng(23.543608464508413, 89.17910557240248),
            ],
            strokeWidth: 2,
            fillColor: Colors.red.withValues(alpha: 0.3),
          ),
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.train),
        onPressed: () {
          _mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(23.543962550247784, 89.17912099510431),
                zoom: 19,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
