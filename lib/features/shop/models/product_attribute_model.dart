import '../../../utils/constants/db_constants.dart';

class ProductAttributeModel {
  String name;
  String value;

  ProductAttributeModel({
    required this.name,
    required this.value
  });

  static ProductAttributeModel empty() => ProductAttributeModel(name: '', value: '');

  //json format
  toJson() {
    return {
      ProductAttributeFieldName.name: name,
      ProductAttributeFieldName.value: value
    };
  }

  //Map json oriented document snapshot form firebase to Model
  factory ProductAttributeModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if(data.isEmpty) return empty();

    return ProductAttributeModel(
      name: data[ProductAttributeFieldName.name] ?? '',
      value: data[ProductAttributeFieldName.value] ?? '',
    );
  }
}