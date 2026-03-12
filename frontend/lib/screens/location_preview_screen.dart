import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

/// Location Preview screen — displays an interactive Google Map
/// with a default camera position, a marker, and full zoom/pan support.
///
/// The map renders immediately on screen load and is fully interactive:
///  • Pinch-to-zoom
///  • Drag to pan
///  • Tap marker to see info window
///  • "My location" button (requires device location permission)
class LocationPreviewScreen extends StatefulWidget {
  const LocationPreviewScreen({super.key});

  static const routeName = '/location-preview';

  @override
  State<LocationPreviewScreen> createState() => _LocationPreviewScreenState();
}

class _LocationPreviewScreenState extends State<LocationPreviewScreen> {
  // Default location: Bangalore, India
  static const _defaultPosition = LatLng(12.9716, 77.5946);
  static const _defaultZoom = 13.0;

  GoogleMapController? _mapController;
  Position? _currentPosition;
  Marker? _userMarker;
  late final Set<Marker> _staticMarkers;
  StreamSubscription<Position>? _positionStream;
  String? _error;

  @override
  void initState() {
    super.initState();
    _staticMarkers = {
      const Marker(
        markerId: MarkerId('default_location'),
        position: _defaultPosition,
        infoWindow: InfoWindow(
          title: 'Bangalore',
          snippet: 'Default location for Location Preview',
        ),
      ),
    };
    _initLocationTracking();
  }

  Future<void> _initLocationTracking() async {
    try {
      final hasPermission = await _handlePermission();
      if (!hasPermission) {
        setState(() => _error = 'Location permission denied.');
        return;
      }

      // Get current position once
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _updatePosition(pos, animateCamera: true);

      // Subscribe to live updates
      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 5,
        ),
      ).listen((pos) {
        _updatePosition(pos);
      });
    } catch (e) {
      setState(() => _error = 'Failed to get location: $e');
    }
  }

  Future<bool> _handlePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _error = 'Location services are disabled on this device.');
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<void> _updatePosition(
    Position pos, {
    bool animateCamera = false,
  }) async {
    final marker = Marker(
      markerId: const MarkerId('user'),
      position: LatLng(pos.latitude, pos.longitude),
      infoWindow: const InfoWindow(title: 'You are here'),
    );

    setState(() {
      _currentPosition = pos;
      _userMarker = marker;
    });

    if (animateCamera && _mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(pos.latitude, pos.longitude),
            zoom: 15,
          ),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  /// Animates camera back to the default position.
  void _resetCamera() {
    if (_currentPosition == null) {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          const CameraPosition(
            target: _defaultPosition,
            zoom: _defaultZoom,
          ),
        ),
      );
    } else {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          15,
        ),
      );
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>{..._staticMarkers};
    if (_userMarker != null) {
      markers.add(_userMarker!);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Location Preview'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Reset to default location',
            icon: const Icon(Icons.my_location),
            onPressed: _resetCamera,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: _defaultPosition,
              zoom: _defaultZoom,
            ),
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: true,
            rotateGesturesEnabled: true,
            mapToolbarEnabled: true,
          ),
          if (_error != null)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
