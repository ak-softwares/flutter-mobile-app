import 'dart:async';

import 'package:aramarket/features/personalization/controllers/user_controller.dart';
import 'package:aramarket/utils/constants/text_strings.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../models/payment_model.dart';
import 'checkout_controller.dart';

class PaymentController extends GetxController {
  static PaymentController get instance => Get.find();

  final userController = Get.put(UserController());
  final checkoutController = Get.put(CheckoutController());

  static List<Map<String, String>> paymentJson = [
    {
      PaymentFieldName.id           : 'razorpay',
      PaymentFieldName.title        : 'Razorpay Payment Gateway',
      PaymentFieldName.description  : 'UPI/QR/Card/NetBanking',
      PaymentFieldName.image        : TImages.razorpay,
      PaymentFieldName.key          : 'rzp_live_w7vTRVX0B8P8av',
      PaymentFieldName.secret       : '6bSr6ZpoCD3wKT5ugMr54qIz',
    },
    {
      PaymentFieldName.id           : 'cod',
      PaymentFieldName.title        : 'COD (Cash on Delivery)',
      PaymentFieldName.description  : 'COD (Cash on Delivery)',
      PaymentFieldName.image        : TImages.cod,
      PaymentFieldName.key          : '',
      PaymentFieldName.secret       : '',
    },
    // {
    //   PaymentFieldName.id           : 'paytm',
    //   PaymentFieldName.title        : 'Paytm Payment Gateway',
    //   PaymentFieldName.description  : 'The best payment gateway provider in India for e-payment through credit card, debit card & netbanking.',
    //   PaymentFieldName.image        : TImages.paytm,
    //   PaymentFieldName.key          : 'cXDKyg79725519213089',
    //   PaymentFieldName.secret       : '2Bl5aVgbd#QgNFwv',
    // },
  ];

  List<PaymentModel> getAllPaymentMethod = PaymentModel.parsePaymentModels(paymentJson);

  final Razorpay _razorpay = Razorpay();

  PaymentController() {
    // Register event listeners during initialization
    _registerEventListeners();
  }

  void _registerEventListeners() {
    // Listen for payment success event
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
      // Notify user about successful payment
      _completer?.complete(response.paymentId);
      // _completer?.complete(response.orderId);
      // _completer?.complete(response.signature);
    });

    // Listen for payment failure event
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
      // Notify user about payment failure
      _completer?.completeError("Payment failed: ${response.message}");
    });

    // Listen for payment cancel event
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse response) {
      // Notify user about payment cancellation
      TLoaders.warningSnackBar(title: 'External Wallet Razorpay:', message: 'Wallet Name: ${response.walletName}');
      _completer?.completeError("Payment cancelled by user.");
    });
  }

  Completer<String>? _completer;

  Future<String> startPayment({required int amount, required String productName}) async {
    // Prepare payment options
    var options = {
      'key': checkoutController.selectedPaymentMethod.value.key,
      'amount': amount * 100, // * 100 Amount in smallest currency unit
      'name': TTexts.appName,
      // 'order_id': 13456,
      'description': productName,
      'prefill': {
        'contact': userController.customer.value.phone,
        'email': userController.customer.value.email,
      },
    };

    // Create a completer to handle async operations
    _completer = Completer<String>();

    try {
      // Open the Razorpay payment interface
      _razorpay.open(options);
    } catch (e) {
      // Handle initialization errors
      _completer?.completeError("Payment initialization failed. Error: $e");
    }

    // Return the future from the completer
    return _completer!.future;
  }

  @override
  void onClose() {
    // Dispose of event listeners when the controller is closed
    _razorpay.clear();
    super.onClose();
  }
}