class GetCategoryModel {
  int? categoryCount;
  int? count;
  List<Result>? result;

  GetCategoryModel({this.categoryCount, this.count, this.result});

  GetCategoryModel.fromJson(Map<String, dynamic> json) {
    categoryCount = json['categoryCount'];
    count = json['count'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryCount'] = this.categoryCount;
    data['count'] = this.count;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? id;
  String? name;
  String? description;
  String? company;
  num? price;
  String? dosageForm;
  String? barcode;
  String? imageUrl;
  List<String>? sideEffects;

  Result(
      {this.id,
      this.name,
      this.description,
      this.company,
      this.price,
      this.dosageForm,
      this.barcode,
      this.imageUrl,
      this.sideEffects});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    company = json['company'];
    price = json['price'];
    dosageForm = json['dosage_form'];
    barcode = json['barcode'];
    imageUrl = json['imageUrl'];
    sideEffects = json['sideEffects'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['company'] = this.company;
    data['price'] = this.price;
    data['dosage_form'] = this.dosageForm;
    data['barcode'] = this.barcode;
    data['imageUrl'] = this.imageUrl;
    data['sideEffects'] = this.sideEffects;
    return data;
  }
}