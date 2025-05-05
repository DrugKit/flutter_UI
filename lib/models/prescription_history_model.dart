class PrescriptionHistoryModel {
  final int id;
  final String imgUrl;
  final String date;
  final String description; // ✅ أضفناها هنا
  final List<PrescriptionDrugModel> prescriptionDrugs;

  PrescriptionHistoryModel({
    required this.id,
    required this.imgUrl,
    required this.date,
    required this.description, // ✅
    required this.prescriptionDrugs,
  });

  factory PrescriptionHistoryModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionHistoryModel(
      id: json['id'],
      imgUrl: json['imgUrl'] ?? '',
      date: json['date'] ?? '',
      description: json['description'] ?? '', // ✅ fallback to empty string
      prescriptionDrugs: (json['prescriptionDrugs'] as List)
          .map((e) => PrescriptionDrugModel.fromJson(e))
          .toList(),
    );
  }
}

class PrescriptionDrugModel {
  final int id;
  final String name;
  final double price;
  final String company;
  final String description;
  final List<String> sideEffects;

  PrescriptionDrugModel({
    required this.id,
    required this.name,
    required this.price,
    required this.company,
    required this.description,
    required this.sideEffects,
  });

  factory PrescriptionDrugModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionDrugModel(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      company: json['company'],
      description: json['description'],
      sideEffects: json['sideEffects'] is List
          ? List<String>.from(json['sideEffects'])
          : [json['sideEffects']?.toString() ?? ''],
    );
  }
}
