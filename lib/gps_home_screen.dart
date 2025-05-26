import 'package:flutter/material.dart';
import 'package:location/location.dart';

class GpsHomeScreen extends StatefulWidget {
  const GpsHomeScreen({super.key});

  @override
  State<GpsHomeScreen> createState() => _GpsHomeScreenState();
}

class _GpsHomeScreenState extends State<GpsHomeScreen> {
  LocationData? currentLocation;
  Future<void> _getCurrentLocation() async {
    // bool isPermissionEnabled = await _isLocationPermissionEnable();
    // if (isPermissionEnabled) {
    //   bool isGpsServiceEnable = await Location.instance.serviceEnabled();
    //   if (isGpsServiceEnable) {
    //     Location.instance.changeSettings(accuracy: LocationAccuracy.high);
    //     LocationData locationData = await Location.instance.getLocation();
    //     print(locationData);
    //     currentLocation = locationData;
    //     setState(() {});
    //   } else {
    //     Location.instance.requestService();
    //   }
    // } else {
    //   bool isPermissionGranted = await _requestPermision();
    //   if (isPermissionGranted) {
    //     _getCurrentLocation();
    //   }
    // }
    _onLocationPermissionAndServiceEnabled(() async {
      LocationData locationData = await Location.instance.getLocation();
      print(locationData);
      currentLocation = locationData;
      setState(() {});
    });
  }

  Future<void> _listenCurrentLocation() async {
    // bool isPermissionEnabled = await _isLocationPermissionEnable();
    // if (isPermissionEnabled) {
    //   bool isGpsServiceEnable = await Location.instance.serviceEnabled();
    //   if (isGpsServiceEnable) {
    //     Location.instance.changeSettings(
    //       accuracy: LocationAccuracy.high,
    //       interval: 10000,
    //       distanceFilter: 10,
    //     );
    //     Location.instance.onLocationChanged.listen((LocationData location) {
    //       print(location);
    //     });
    //   } else {
    //     Location.instance.requestService();
    //   }
    // } else {
    //   bool isPermissionGranted = await _requestPermision();
    //   if (isPermissionGranted) {
    //     _listenCurrentLocation();
    //   }
    // }
    _onLocationPermissionAndServiceEnabled(() {
      Location.instance.changeSettings(
        accuracy: LocationAccuracy.high,
        interval: 10000,
        distanceFilter: 10,
      );
      Location.instance.onLocationChanged.listen((LocationData location) {
        print(location);
      });
    });
  }

  Future<void> _onLocationPermissionAndServiceEnabled(
    VoidCallback onSuccess,
  ) async {
    bool isPermissionEnabled = await _isLocationPermissionEnable();
    if (isPermissionEnabled) {
      bool isGpsServiceEnable = await Location.instance.serviceEnabled();
      if (isGpsServiceEnable) {
        Location.instance.changeSettings(
          accuracy: LocationAccuracy.high,
          interval: 10000,
          distanceFilter: 10,
        );

        onSuccess();
      } else {
        Location.instance.requestService();
      }
    } else {
      bool isPermissionGranted = await _requestPermision();
      if (isPermissionGranted) {
        _listenCurrentLocation();
      }
    }
  }

  Future<bool> _isLocationPermissionEnable() async {
    PermissionStatus locationPermission =
        await Location.instance.hasPermission();
    if (locationPermission == PermissionStatus.granted ||
        locationPermission == PermissionStatus.grantedLimited) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _requestPermision() async {
    PermissionStatus permissionStatus =
        await Location.instance.requestPermission();
    if (permissionStatus == PermissionStatus.granted ||
        permissionStatus == PermissionStatus.grantedLimited) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gps Service')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current location ${currentLocation?.latitude},${currentLocation?.longitude},',
            ),
            TextButton(
              onPressed: () {
                _getCurrentLocation();
              },
              child: const Text('Get current location'),
            ),
            // Text(
            //   'Current location ${currentLocation?.latitude},${currentLocation?.longitude},',
            // ),
            TextButton(
              onPressed: () {
                _listenCurrentLocation();
              },
              child: const Text('Listen current location'),
            ),
          ],
        ),
      ),
    );
  }
}
