import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  // Markers displayed on the map
  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('default_location'),
      position: _defaultPosition,
      infoWindow: InfoWindow(
        title: 'Bangalore',
        snippet: 'Default location for Location Preview',
      ),
    ),
  };

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  /// Animates camera back to the default position.
  void _resetCamera() {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: _defaultPosition,
          zoom: _defaultZoom,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Preview'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Reset to default location',
            icon: const Icon(Icons.my_location),
            onPressed: _resetCamera,
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: _defaultPosition,
          zoom: _defaultZoom,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        tiltGesturesEnabled: true,
        rotateGesturesEnabled: true,
        mapToolbarEnabled: true,
      ),
    );
  }
}
