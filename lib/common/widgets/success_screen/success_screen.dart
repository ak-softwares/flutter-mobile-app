import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';

import '../../../features/shop/controllers/order/order_controller.dart';
import '../../../features/shop/models/order_model.dart';
import '../../../features/shop/screens/orders/orders.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/icons.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/navigation_helper.dart';
import '../../styles/spacing_style.dart';
import '../../dialog_box_massages/full_screen_loader.dart';
import '../../dialog_box_massages/snack_bar_massages.dart';

class TSuccessScreen extends StatefulWidget {
  const TSuccessScreen({
    super.key,
    required this.order
  });
  final OrderModel order;

  @override
  State<TSuccessScreen> createState() => _TSuccessScreenState();
}

class _TSuccessScreenState extends State<TSuccessScreen> {
  final orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    // Delay execution until the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processPayment();
    });  }

  Future<void> _processPayment() async {
    if(widget.order.paymentMethod == PaymentMethods.razorpay.name &&
        widget.order.status == OrderStatus.pendingPayment){
      await orderController.makePayment(order: widget.order);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWidthAppbarHeight *2,
          child: Column(
            children: [
              //Image
              Lottie.asset(Images.orderCompletedAnimation, width: MediaQuery.of(context).size.width * 0.6),
              const SizedBox(height: 60),

              //Title and SubTitle
              Text(widget.order.status == OrderStatus.pendingPayment
                  ? 'Order in Pending! #${widget.order.id}'
                  : 'Order Placed! #${widget.order.id}',
                  style: TextStyle(fontSize: 25)
              ),
              const SizedBox(height: AppSizes.spaceBtwItems),
              Text('Thank you for your purchase. Order status is ${widget.order.status?.prettyName}', style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppSizes.spaceBtwSection),

              //Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Get.off(() => const OrderScreen())?.then((value) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        NavigationHelper.navigateToBottomNavigation();
                      });
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(AppIcons.bottomNavigationCart, color: Colors.black, size: 20,),
                      const SizedBox(width: AppSizes.inputFieldSpace),
                      const Text('Go to My Orders'),
                    ],
                  )
                ),
              ),
              const SizedBox(height: AppSizes.inputFieldSpace),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => NavigationHelper.navigateToBottomNavigation(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(AppIcons.home, color: Theme.of(context).colorScheme.onSurface, size: 20),
                      const SizedBox(width: AppSizes.inputFieldSpace),
                      const Text('Go to Home'),
                    ],
                  )
                ),
              ),

              if(widget.order.paymentMethod == PaymentMethods.razorpay.name &&
                  widget.order.status == OrderStatus.pendingPayment)
               Column(
                children: [
                  const SizedBox(height: AppSizes.inputFieldSpace),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () async =>  await orderController.makePayment(order: widget.order),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.money, color: Theme.of(context).colorScheme.onSurface, size: 20),
                            const SizedBox(width: AppSizes.inputFieldSpace),
                            const Text('Make Payment'),
                          ],
                        )
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
