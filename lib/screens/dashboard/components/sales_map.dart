import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../constants.dart';

class SalesMap extends StatelessWidget {
  const SalesMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Sales by Regions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textPrimaryColor,
                ),
              ),
              DropdownButton<String>(
                value: 'India',
                items: const [
                  DropdownMenuItem(value: 'India', child: Text('India', style: TextStyle(color: textPrimaryColor))),
                ],
                onChanged: (v) {},
                underline: const SizedBox(),
                icon: const Icon(Icons.expand_more, size: 20, color: textSecondaryColor),
              )
            ],
          ),
          const SizedBox(height: defaultPadding),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: const LatLng(21.5937, 78.9629), // Centerish of India
                  initialZoom: 4.2,
                  interactionOptions: const InteractionOptions(
                    enableMultiFingerGestureRace: true,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.tajpro.app',
                  ),
                  MarkerLayer(
                    markers: [
                      _buildMarker(const LatLng(28.6139, 77.2090), "Delhi", "\$312,450"),
                      _buildMarker(const LatLng(19.0760, 72.8777), "Mumbai", "\$1,245,680", isHighlight: true),
                      _buildMarker(const LatLng(12.9716, 77.5946), "Bangalore", "\$684,320"),
                      _buildMarker(const LatLng(13.0827, 80.2707), "Chennai", "\$158,970"),
                      _buildMarker(const LatLng(22.5726, 88.3639), "Kolkata", "\$120,000"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Marker _buildMarker(LatLng position, String city, String sales, {bool isHighlight = false}) {
    return Marker(
      point: position,
      width: 140,
      height: 60,
      alignment: Alignment.topCenter,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isHighlight ? const Color(0xFF1E293B) : Colors.black87, // Dark slate or black like in design
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: isHighlight ? Border.all(color: primaryColor, width: 2) : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 8,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    city,
                    style: TextStyle(
                      color: isHighlight ? Colors.white : Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                sales,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
