import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/constants/db_constants.dart';

class BannerModel {
  String imageUrl;
  final String? targetScreen;

  BannerModel({required this.imageUrl, this.targetScreen});

  Map<String, dynamic> toJson(){
    return {
      BannerFieldName.imageUrl: imageUrl,
      BannerFieldName.targetScreen: targetScreen,
    };
  }

  factory BannerModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return BannerModel(
        imageUrl: data[BannerFieldName.imageUrl],
        targetScreen: data[BannerFieldName.targetScreen],
    );
  }
}