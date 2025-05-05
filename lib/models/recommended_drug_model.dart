class DrugRecommendationModel {
  final int id;
  final String name;
  final String? description;
  final String? company;
  final String? dosageForm;
  final String? imageUrl;
  final double price;
  final List<String>? sideEffects;

  DrugRecommendationModel({
    required this.id,
    required this.name,
    this.description,
    this.company,
    this.dosageForm,
    this.imageUrl,
    required this.price,
    this.sideEffects,
  });

  factory DrugRecommendationModel.fromJson(Map<String, dynamic> json) {
    return DrugRecommendationModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      company: json['company'],
      dosageForm: json['dosage_form'],
      imageUrl: json['imageUrl'],
      price: (json['price'] as num).toDouble(),
      sideEffects: List<String>.from(json['sideEffects'] ?? []),
    );
  }
}
