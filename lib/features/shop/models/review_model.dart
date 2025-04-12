import '../../../utils/constants/db_constants.dart';

class ReviewModel {
  int? id;
  String? dateCreated;
  int? productId;
  String? productName;
  String? productPermalink;
  String? status;
  String? reviewer;
  String? reviewerEmail;
  String? review;
  String? image;
  int? rating;
  bool? verified;
  String? reviewerAvatarUrl;

  ReviewModel({
    this.id,
    this.dateCreated,
    this.productId,
    this.productName,
    this.productPermalink,
    this.status,
    this.reviewer,
    this.reviewerEmail,
    this.review,
    this.image,
    this.rating,
    this.verified,
    this.reviewerAvatarUrl,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json, { bool isCustomApi = false}) {
    final avatarMap = json[ReviewFieldName.reviewerAvatarUrls];

    return ReviewModel(
      id: json[ReviewFieldName.id] ?? 0,
      dateCreated: json[ReviewFieldName.dateCreated] ?? '',
      productId: json[ReviewFieldName.productId] ?? 0,
      productName: json[ReviewFieldName.productName] ?? '',
      productPermalink: json[ReviewFieldName.productPermalink] ?? '',
      status: json[ReviewFieldName.status] ?? '',
      reviewer: json[ReviewFieldName.reviewer] ?? '',
      reviewerEmail: json[ReviewFieldName.reviewerEmail] ?? '',
      review: json[ReviewFieldName.review] ?? '',
      image: json[ReviewFieldName.image] ?? '',
      rating: json[ReviewFieldName.rating] ?? 0,
      verified: json[ReviewFieldName.verified] ?? false,
      // Because this data come form custom Api not woocommerce api
      reviewerAvatarUrl: isCustomApi
          ? avatarMap ?? ''
          : avatarMap != null && avatarMap.containsKey('48') ? avatarMap['48'] : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ReviewFieldName.productId: productId,
      ReviewFieldName.review: review,
      ReviewFieldName.reviewer: reviewer,
      ReviewFieldName.reviewerEmail: reviewerEmail,
      ReviewFieldName.rating: rating,
      ReviewFieldName.reviewerAvatarUrls: reviewerAvatarUrl,
    };
  }

}
