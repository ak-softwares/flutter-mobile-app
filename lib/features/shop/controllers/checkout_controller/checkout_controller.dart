import 'package:get/get.dart';

import '../../../../utils/constants/text_strings.dart';
import '../../models/coupon_model.dart';
import '../../models/payment_model.dart';
import '../cart_controller/cart_controller.dart';
import '../product/order_controller.dart';
import 'payment_controller.dart';

class CheckoutController extends GetxController{
  static CheckoutController get instance => Get.find();

  // Observable variables
  RxDouble subTotal = 0.0.obs;
  RxDouble shipping = 0.0.obs;
  RxBool isFreeShipping = false.obs;
  RxDouble discount = 0.0.obs;
  RxDouble tax = 0.0.obs;
  RxDouble total = 0.0.obs;

  final double shippingPrice = 100.0;
  Rx<CouponModel> coupon = CouponModel().obs;
  Rx<PaymentModel> selectedPaymentMethod = PaymentModel.empty().obs;

  final cartController = Get.put(CartController());

  @override
  void onInit() {
    super.onInit();

    // Assign the value of totalCartPrice directly to subTotal
    subTotal.value = cartController.totalCartPrice.value;
    // Listen to changes in totalCartPrice and update subTotal accordingly
    ever(cartController.totalCartPrice, (_) {subTotal.value = cartController.totalCartPrice.value; updateTotal();});
    updateTotal();
  }

  Future<void> initiateCheckout() async {
    await Get.put(OrderController()).saveOrderByCustomerId();
  }

  void updateSelectedPaymentOption(PaymentModel paymentMethod) {
    selectedPaymentMethod.value = paymentMethod;
  }

  // Function to update subTotal
  void updateSubTotal(double value) {
    subTotal.value = value;
    updateTotal();
  }

  // Function to update discount based on coupon details
  void updateDiscount() {
    updateTotal();
  }

  // Function to update shipping
  void updateShipping(double value) {
    shipping.value = calculateShippingCost(value);
    updateTotal();
  }

  // Function to update tax
  void updateTax(double value) {
    tax.value = value;
    updateTotal();
  }

  // Function to calculate total
  void updateTotal() {
    discount.value = calculateDiscount(subTotal.value, coupon.value);
    shipping.value = calculateShippingCost(subTotal.value);
    total.value = (subTotal.value - discount.value) + shipping.value + tax.value;
  }

  // Function to calculate discount based on coupon
  double calculateDiscount(double subTotal, CouponModel coupon) {
    final discountValue = double.tryParse(coupon.amount ?? '') ?? 0;
    final maxDiscount = double.tryParse(coupon.maxDiscount ?? '') ?? 0;
    final discountType = coupon.discountType ?? '';
    if (coupon.isFreeShipping()) {
      isFreeShipping.value = true;
      return 0; // Or handle it according to your requirements
    } else {
      isFreeShipping.value = false;
      if (discountType.toLowerCase() == 'flat') {
        // Flat discount
        return discountValue;
      } else if (discountType.toLowerCase() == 'percent') {
        // Percentage discount
        final calDiscount = subTotal * (discountValue / 100);
        if(maxDiscount != 0){
          return calDiscount > maxDiscount ? maxDiscount : calDiscount;
        }else {
          return calDiscount;
        }
      } else {
        // Invalid discount type
        return 0; // Or handle it according to your requirements
      }
    }
  }

  // Function to calculate shipping cost
  double calculateShippingCost(double subtotal) {
    if(isFreeShipping.value){
      return 0;
    }else if(subtotal > 980) {
      return 0;
    }
    return shippingPrice;
  }
}