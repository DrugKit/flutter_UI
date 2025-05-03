class NearestPharmacyModel {
  final String name;
  final String? address;
  final double latitude;
  final double longitude;
  final double distance;
  final String? phoneNumber;

  NearestPharmacyModel({
    required this.name,
    this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
    this.phoneNumber,
  });

  factory NearestPharmacyModel.fromJson(Map<String, dynamic> json) {
    return NearestPharmacyModel(
      name: json['name'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      distance: (json['distance'] as num).toDouble(),
      phoneNumber: json['phoneNumber'],
    );
  }
}
