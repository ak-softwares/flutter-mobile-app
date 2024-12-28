
import '../../../utils/constants/db_constants.dart';
import '../controllers/checkout_controller/checkout_controller.dart';

class CouponModel {
  final int? id;
  final String? code;
  final String? amount;
  final String? dateCreated;
  final String? discountType;
  final String? description;
  final String? dateExpires;
  final bool? freeShipping;
  final bool? individualUse;
  final String? minimumAmount;
  final String? maximumAmount;
  final List<String>? paymentMethods;
  final String? maxDiscount;
  final bool? isCODBlocked;

  CouponModel({
    this.id,
    this.code,
    this.amount,
    this.dateCreated,
    this.discountType,
    this.description,
    this.dateExpires,
    this.freeShipping,
    this.individualUse,
    this.minimumAmount,
    this.maximumAmount,
    this.paymentMethods,
    this.maxDiscount,
    this.isCODBlocked,
  });
  static CouponModel empty() => CouponModel();

  String? getValidityErrorMessage() {

    // Check if the coupon is expired
    if (dateExpires != null && DateTime.parse(dateExpires!).isBefore(DateTime.now())) {
      return 'Coupon is expired';
    }

    // Check if the paymentMethods list is null or empty, in which case there are no restrictions
    // if (paymentMethods == null || paymentMethods!.isEmpty || paymentMethods!.every((element) => element.trim().isEmpty)) {
    //   return null;
    // }
    //
    // // Printing the selected payment method and its type
    var selectedPaymentMethod = CheckoutController.instance.selectedPaymentMethod.value.id;
    // Check if the selected payment method is not allowed
    // if (!paymentMethods!.contains(selectedPaymentMethod)) {
    //   return 'This coupon is not allowed for $selectedPaymentMethod.';
    // }

    if (code == 'prepaidapp10') {
      if(selectedPaymentMethod == 'razorpay'){
        return null;
      }else{
        return 'This coupon is not allowed for cod.';
      }
    }
    return null;
  }

  bool areAllPropertiesNull() {
    return id == null &&
        code == null &&
        amount == null &&
        dateCreated == null &&
        discountType == null &&
        description == null &&
        dateExpires == null &&
        freeShipping == null &&
        individualUse == null &&
        minimumAmount == null &&
        maximumAmount == null &&
        paymentMethods == null &&
        maxDiscount == null;
  }

  bool isFreeShipping() {
    // Check if the coupon provides free shipping
    return freeShipping ?? false;
  }

  bool isIndividualUse() {
    // Check if the coupon provides free shipping
    return individualUse ?? false;
  }

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    // Extract meta_data from JSON
    // List<dynamic> metaData = json[CouponFieldName.metaData];
    // Extract meta_data from JSON
    List<dynamic> metaData = json[CouponFieldName.metaData];

    // Initialize variables to hold paymentMethods and maxDiscount
    List<String>? paymentMethods;

    // Loop through metaData to find and extract values
    for (var meta in metaData) {
      String key = meta['key'];

      // Extract paymentMethods
      if (key == CouponFieldName.paymentMethods) {
        paymentMethods = meta['value'].split(',');
      }
    }
    return CouponModel(
      id: json[CouponFieldName.id],
      code: json[CouponFieldName.code],
      amount: json[CouponFieldName.amount],
      dateCreated: json[CouponFieldName.dateCreated],
      discountType: json[CouponFieldName.discountType],
      description: json[CouponFieldName.description],
      dateExpires: json[CouponFieldName.dateExpires],
      freeShipping: json[CouponFieldName.freeShipping],
      individualUse: json[CouponFieldName.individualUse],
      minimumAmount: json[CouponFieldName.minimumAmount],
      maximumAmount: json[CouponFieldName.maximumAmount],
      paymentMethods: paymentMethods,
      maxDiscount: (json[CouponFieldName.metaData] as List?)?.firstWhere((meta) => meta['key'] == CouponFieldName.maxDiscount, orElse: () => {'value': ''},)['value'] ?? '',
      isCODBlocked: (json[CouponFieldName.metaData] as List?)?.any((meta) => meta['key'] == CouponFieldName.isCODBlocked && meta['value'] == "1") ?? false,

    );
  }

  Map<String, dynamic> toJsonForWoo() {
    return {
      CouponFieldName.code: code,
    };
  }

}
