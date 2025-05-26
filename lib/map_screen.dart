import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class AutoLocationMapScreen extends StatefulWidget {
  const AutoLocationMapScreen({super.key});

  @override
  State<AutoLocationMapScreen> createState() => _AutoLocationMapScreenState();
}

class _AutoLocationMapScreenState extends State<AutoLocationMapScreen> {
  GoogleMapController? _mapController;
  LocationData? _currentLocation;
  final Location _location = Location();

  Marker? _userMarker;
  List<LatLng> _polylinePoints = [];
  Polyline? _polyline;

  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    if (!await _location.serviceEnabled()) {
      await _location.requestService();
    }
    PermissionStatus permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.deniedForever) {
      permission = await _location.requestPermission();
      if (permission != PermissionStatus.granted &&
          permission != PermissionStatus.grantedLimited) {
        return;
      }
    }
    final locationData = await _location.getLocation();
    _updateLocation(locationData, animate: true);

    _location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 10000,
      // distanceFilter: 5,
    );
    _locationSubscription = _location.onLocationChanged.listen((locationData) {
      _updateLocation(locationData, animate: true);
    });
  }

  void _updateLocation(
    LocationData locationData, {
    bool animate = false,
  }) async {
    setState(() {
      _currentLocation = locationData;

      final latlng = LatLng(locationData.latitude!, locationData.longitude!);
      _polylinePoints.add(latlng);

      _userMarker = Marker(
        markerId: const MarkerId('user'),
        position: latlng,
        infoWindow: InfoWindow(
          title: 'My current location',
          snippet:
              'Lat: ${latlng.latitude.toStringAsFixed(6)}, Lng: ${latlng.longitude.toStringAsFixed(6)}',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );

      _polyline = Polyline(
        polylineId: const PolylineId('user-path'),
        color: Colors.blue,
        width: 4,
        points: List<LatLng>.from(_polylinePoints),
      );
    });

    if (_mapController != null && animate) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(locationData.latitude!, locationData.longitude!),
        ),
      );
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LatLng initialPos =
        _currentLocation == null
            ? const LatLng(37.43248808749647, -121.92617066435402)
            : LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Auto Location Map',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition: CameraPosition(target: initialPos, zoom: 18),
        compassEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (controller) {
          _mapController = controller;
          // Animate on first build if location is available
          if (_currentLocation != null) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(
                  _currentLocation!.latitude!,
                  _currentLocation!.longitude!,
                ),
              ),
            );
          }
        },
        markers: _userMarker != null ? {_userMarker!} : {},
        polylines: _polyline != null ? {_polyline!} : {},
      ),
    );
  }
}
