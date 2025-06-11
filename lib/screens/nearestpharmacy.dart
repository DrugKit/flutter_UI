import 'package:drugkit/logic/nearest_pharmacy/nearest_pharmacy_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NearestPharmacyScreen extends StatefulWidget {
  const NearestPharmacyScreen({super.key});

  @override
  State<NearestPharmacyScreen> createState() => _NearestPharmacyScreenState();
}

class _NearestPharmacyScreenState extends State<NearestPharmacyScreen> {
  double? lat;
  double? lon;
  bool isFetchingLocation = true;

  @override
  void initState() {
    super.initState();
    _determinePositionAndFetch();
  }

  Future<void> _determinePositionAndFetch() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationError("Location services are disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          _showLocationError("Location permission denied.");
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        lat = position.latitude;
        lon = position.longitude;
        isFetchingLocation = false;
      });

      if (lat != null && lon != null) {
        context.read<NearestPharmacyCubit>().fetchNearestPharmacies(lat!, lon!);
      }
    } catch (e) {
      _showLocationError("Failed to get location: $e");
    }
  }

  void _showLocationError(String message) {
    setState(() {
      isFetchingLocation = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }


void _openMap(double latitude, double longitude) async {
  final url = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

  final success = await launchUrlString(url, mode: LaunchMode.externalApplication);
  
  if (!success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Could not open Google Maps")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: const BackButton(),
        title: const Text(
          'Nearest Pharmacy',
          style: TextStyle(
            color: Color(0xFF0C1467),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0C1467),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lat != null
                        ? "Lat: ${lat!.toStringAsFixed(5)}, Lon: ${lon!.toStringAsFixed(5)}"
                        : (isFetchingLocation
                            ? "Fetching location..."
                            : "Location unavailable"),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Icon(Icons.location_on, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<NearestPharmacyCubit, NearestPharmacyState>(
                builder: (context, state) {
                  if (state is NearestPharmacyLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NearestPharmacySuccess) {
                    return GridView.builder(
                      itemCount: state.pharmacies.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        final pharmacy = state.pharmacies[index];
                        return GestureDetector(
                          onTap: () =>
                              _openMap(pharmacy.latitude, pharmacy.longitude),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F6F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    'assets/location.png',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  pharmacy.name,
                                  style: const TextStyle(
                                    color: Color(0xFF0C1467),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${pharmacy.distance.toStringAsFixed(1)} meters away',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                if (pharmacy.phoneNumber != null)
                                  Text(
                                    'Phone: ${pharmacy.phoneNumber}',
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is NearestPharmacyError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const Center(child: Text("No data yet."));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
