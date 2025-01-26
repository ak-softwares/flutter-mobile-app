import '../../../utils/constants/db_constants.dart';

class ProductBrand {
  final int? id;
  final String? name;
  final String? slug;
  final String? imageUrl;  // Added field for image URL

  // Constructor
  ProductBrand({
    this.id,
    this.name,
    this.slug,
    this.imageUrl,
  });

  // Factory method to create a Brand object from a JSON map
  factory ProductBrand.fromJson(Map<String, dynamic> json) {
    return ProductBrand(
      id: json[ProductBrandFieldName.id] ?? 0,
      name: json[ProductBrandFieldName.name] ?? '',
      slug: json[ProductBrandFieldName.slug] ?? '',
      imageUrl: json[ProductBrandFieldName.imageUrl] ?? '',  // Assuming the image URL is in the 'image_url' field
    );
  }

  // Method to convert Brand object back to JSON map
  Map<String, dynamic> toJson() {
    return {
      ProductBrandFieldName.id: id,
      ProductBrandFieldName.name: name,
      ProductBrandFieldName.slug: slug,
      ProductBrandFieldName.imageUrl: imageUrl,  // Include image URL in the JSON map
    };
  }
}
