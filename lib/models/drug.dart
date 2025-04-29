class DrugModel {
  final String name;

  DrugModel({required this.name});

  factory DrugModel.fromJson(dynamic json) {
    // لان اللي جاي نص مش ماب
    return DrugModel(name: json.toString());
  }
}
