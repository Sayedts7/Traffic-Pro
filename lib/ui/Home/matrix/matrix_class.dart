import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class DistanceMatrixService {
  final String apiKey;

  DistanceMatrixService(this.apiKey);

  Future<Map<String, dynamic>> getDistanceAndDuration({
    required String origin,
    required String destination,
    String mode = 'driving', // Default to driving
  }) async {
    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$origin&destinations=$destination&mode=$mode&key=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        // Fetch route details
        final routeResponse = await http.get(
          Uri.parse(
            'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=$mode&key=$apiKey',
          ),
        );

        if (routeResponse.statusCode == 200) {
          final routeData = jsonDecode(routeResponse.body);
          if (routeData['status'] == 'OK') {
            final steps = routeData['routes'][0]['legs'][0]['steps'];
            List<LatLng> polylinePoints = [];
            for (var step in steps) {
              final startLocation = step['start_location'];
              polylinePoints.add(LatLng(startLocation['lat'], startLocation['lng']));
              final endLocation = step['end_location'];
              polylinePoints.add(LatLng(endLocation['lat'], endLocation['lng']));
            }

            return {
              'distance': data['rows'][0]['elements'][0]['distance']['text'],
              'duration': data['rows'][0]['elements'][0]['duration']['text'],
              'polylinePoints': polylinePoints,
            };
          } else {
            throw Exception('Error: ${routeData['status']}');
          }
        } else {
          throw Exception('Failed to load directions');
        }
      } else {
        throw Exception('Error: ${data['status']}');
      }
    } else {
      throw Exception('Failed to load distance matrix');
    }
  }
}
