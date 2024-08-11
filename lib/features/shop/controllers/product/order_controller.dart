import 'package:aramarket/features/shop/models/payment_model.dart';
import 'package:aramarket/features/shop/screens/orders/order.dart';
import 'package:aramarket/utils/helpers/navigation_helper.dart';
import 'package:get/get.dart';

import '../../../../common/navigation_bar/bottom_navigation_bar2.dart';
import '../../../../common/widgets/loaders/loader.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../common/widgets/success_screen/success_screen.dart';
import '../../../../data/repositories/firebase/orders/order_repository.dart';
import '../../../../data/repositories/woocommerce_repositories/orders/woo_orders_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../personalization/controllers/address_controller.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../models/coupon_model.dart';
import '../../models/order_model.dart';
import '../cart_controller/cart_controller.dart';
import '../checkout_controller/checkout_controller.dart';
import '../checkout_controller/payment_controller.dart';
import '../coupon/coupon_controller.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  //Variables
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  final RxList<OrderModel> orders = <OrderModel>[].obs;

  final cartController = Get.put(CartController());
  final addressController = AddressController.instance;
  final checkoutController = Get.put(CheckoutController());
  final wooOrdersRepository = Get.put(WooOrdersRepository());
  final orderRepository = Get.put(OrderRepository());
  final userController = Get.put(UserController());
  final paymentController = Get.put(PaymentController());
  final couponController = Get.put(CouponController());

  //Fetch orders
  Future<void> fetchOrders() async {
    try {
      final customerId = userController.customer.value.id.toString();
      final customerEmail = userController.customer.value.email.toString();

      final List<OrderModel> ordersByCustomerId =
          await wooOrdersRepository.fetchOrdersByCustomerId(customerId: customerId, page: currentPage.toString());
      final List<OrderModel> ordersByCustomerEmail = await wooOrdersRepository
          .fetchOrdersByCustomerEmail(customerEmail: customerEmail,page: currentPage.toString());


      final List<OrderModel> mergedOrders = [...ordersByCustomerId, ...ordersByCustomerEmail];

      // Define a function to check if two orders are equal based on some unique identifier
      bool areOrdersEqual(OrderModel order1, OrderModel order2) {
        return order1.id == order2.id; // Assuming `id` is a unique identifier for orders
      }

      // Remove duplicates from the merged list
      final List<OrderModel> uniqueOrders = [];
      for (var order in mergedOrders) {
        // Check if the order already exists in the unique orders list
        bool alreadyExists = uniqueOrders.any((existingOrder) => areOrdersEqual(existingOrder, order));
        // If the order doesn't exist in the unique orders list, add it
        if (!alreadyExists) {
          uniqueOrders.add(order);
        }
      }

      // Sort the merged orders by date
      uniqueOrders.sort((a, b) => b.parsedCreatedDate.compareTo(a.parsedCreatedDate));

      orders.addAll(uniqueOrders);
    } catch (e) {
    TLoaders.warningSnackBar(title: 'Error', message: e.toString());
    }
  }

  //Get user order by customer id
  Future<void> getOrdersByCustomerId() async {
    try {
      var customerId = userController.customer.value.id;
      if(customerId == null){
        await userController.refreshCustomer();
        customerId = userController.customer.value.id;
      }
      final newOrders = await wooOrdersRepository.fetchOrdersByCustomerId(customerId: customerId.toString(), page: currentPage.toString());
      orders.addAll(newOrders);
    } catch (e) {
      TLoaders.warningSnackBar(title: 'Error', message: e.toString());
    }
  }

  //Get user order by customer Email
  Future<void> getOrdersByCustomerEmail() async {
    try {
      String customerEmail = userController.customer.value.email.toString();
      if(customerEmail.isEmpty){
        await userController.refreshCustomer();
        customerEmail = userController.customer.value.email.toString();
      }
      final newOrders = await wooOrdersRepository.fetchOrdersByCustomerEmail(customerEmail: customerEmail, page: currentPage.toString());
      orders.addAll(newOrders);
    } catch (e) {
      TLoaders.warningSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Function to refresh orders
  Future<void> refreshOrders() async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      orders.clear(); // Clear existing orders
      await getOrdersByCustomerId();
      // await fetchOrders();
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Error', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

  // Add methods for order processing
  Future<void> saveOrderByCustomerId() async {
    String transactionId = '';
    try {
      //start loader
      TFullScreenLoader.openLoadingDialog('Processing your order', TImages.docerAnimation);

      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //validate coupon
      couponController.validateCoupon(checkoutController.coupon.value);

      // Validate Address Phone and Email
      List<String> validationErrors = userController.customer.value.billing!.validateFields();
      if (validationErrors.isNotEmpty) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'Error', message: '"${validationErrors.join(', ')}", Update in Address');
        return;
      }

      // Check Payment Method
      final PaymentModel paymentMethod = checkoutController.selectedPaymentMethod.value;
      if (paymentMethod.id.isEmpty) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'Error', message: 'Please select payment Method');
        return;
      } else if(paymentMethod.id == TTexts.razorpay) {
        // Start the payment process
        String paymentId = await paymentController.startPayment(amount: checkoutController.total.value.toInt(), productName: 'Products');
        if (paymentId.isNotEmpty) {
          transactionId = paymentId;
          TLoaders.successSnackBar(title: 'Payment Successful:', message: 'Payment ID: $paymentId');
        } else {
          TFullScreenLoader.stopLoading();
          TLoaders.errorSnackBar(title: 'Error', message: "Payment failed!");
          return;
        }
      } else if(paymentMethod.id == TTexts.paytm) {
        // Handle Paytm payment method
      } else {
        // Handle other payment methods like - 'cod'
      }

      //Add Details
      final order = OrderModel(
        customerId: userController.customer.value.id,
        paymentMethod: checkoutController.selectedPaymentMethod.value.id,
        paymentMethodTitle: checkoutController.selectedPaymentMethod.value.title,
        // paymentMethod: 'Paytm Payment Gateway', //Payment method ID. 'Paytm Payment Gateway'
        // paymentMethodTitle: 'razorpay', //Payment method title.  // 'UPI/QR/Card/NetBanking' 'Paytm Payment Gateway'
        transactionId: transactionId,
        setPaid: true,
        status: "processing",
        billing:   userController.customer.value.billing,
        shipping:   userController.customer.value.billing, //if shipping address is different then use shipping instead billing
        lineItems:  cartController.cartItems,
        couponLines: [checkoutController.coupon.value],
        metaData: [
          OrderMedaDataModel(key: "_wc_order_attribution_source_type", value: "organic"), //referral, organic, Unknown, utm, Web Admin, typein (Direct)
          OrderMedaDataModel(key: "_wc_order_attribution_utm_source", value: "Android App")
          // OrderMedaDataModel(key: "_wc_order_attribution_referrer", value: "https://www.google.com/"), //this only use for referral
          // OrderMedaDataModel(key: "_wc_order_attribution_utm_medium", value: "organic"),
          // OrderMedaDataModel(key: "_wc_order_attribution_utm_medium", value: "organic"),
        ],
      );

      //save the order to firebase
      final OrderModel createdOrder = await wooOrdersRepository.createOrderByCustomerId(order);
      //update the cart status
      cartController.clearCart();
      checkoutController.coupon.value = CouponModel.empty();
      checkoutController.updateTotal();
      TFullScreenLoader.stopLoading();
      //Show success screen
      Get.offAll(() => TSuccessScreen(
        image: TImages.orderCompletedAnimation,
        title: 'Payment Success! #${createdOrder.id}',
        subTitle: 'Your order status is ${createdOrder.status}',
        // In the onPressed callback of TSuccessScreen
        onPressed: () async {
          // Close current screen
          Get.close(1);
          // Navigate to TOrderScreen
          Get.to(() => const TOrderScreen())?.then((value) {
            // After returning from TOrderScreen, navigate to home screen
            NavigationHelper.navigateToBottomNavigation();
            // Get.offAll(() => const BottomNavigation2());
          });
        }

      ));
    } catch(error) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: error.toString());
    }
  }

  //Cancel order
  Future<void> cancelOrder(String orderId) async {
    try {
      CartController.instance.isCancelLoading(true);
      final updatedOrder  = await wooOrdersRepository.updateStatusByOrderId(orderId, 'cancelled');
      // Find the index of the order with the matching orderId in the orders list
      final int index = orders.indexWhere((order) => order.id == updatedOrder.id);

      if (index != -1) {
        // If the order is found, replace it with the updated order
        orders[index] = updatedOrder;
      } else {
        // If the order is not found, add the updated order to the list
        orders.add(updatedOrder);
      }
    } catch (error) {
      TLoaders.errorSnackBar(title: 'Error', message: error.toString());
    } finally {
      CartController.instance.isCancelLoading(false);
    }
  }
}