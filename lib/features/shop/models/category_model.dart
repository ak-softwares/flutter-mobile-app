import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/constants/db_constants.dart';

class CategoryModel {
  String? id;
  String? name;
  String? image;
  String? parentId;

  CategoryModel({
    this.id,
    this.name,
    this.image,
    this.parentId,
  });

  //Empty Helper Function
  static CategoryModel empty() => CategoryModel();

  //Convert Model data to json so that you can upload data to firebase
  Map<String, dynamic> toJson() {
    return {
      CategoryFieldName.id: id,
      CategoryFieldName.name: name,
      CategoryFieldName.image: image,
      CategoryFieldName.parentId: parentId,
    };
  }

  //map json oriented document snapshot form firebase to userModel
  factory CategoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
   if(document.data() != null) {
     final data = document.data()!;
     //map json recode to the model
     return CategoryModel(
         id: document.id,
         name: data[CategoryFieldName.name] ?? '',
         image: data[CategoryFieldName.image] ?? '',
         parentId: data[CategoryFieldName.parentId] ?? '',
     );
   }else {
     return CategoryModel.empty();
   }
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'].toString(),
      name: (json['name']).replaceAll('&amp;', '&') ?? '',
      image: json['image'] != null && json['image'].isNotEmpty ? json['image']['src'] : '',
    );
  }
}