import 'package:aramarket/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../../common/text/section_heading.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/checkout_controller/checkout_controller.dart';
import '../../../controllers/checkout_controller/payment_controller.dart';
import '../../../models/payment_model.dart';

class TBillingPaymentSection extends StatelessWidget {
  const TBillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentController = Get.put(PaymentController());
    final checkoutController = CheckoutController.instance;
    checkoutController.selectedPaymentMethod.value = paymentController.getAllPaymentMethod.first;
    return Column(
      children: [
        const TSectionHeading(title: 'Payment Method'),
        Column(
          children: [
            for (var paymentMethod in paymentController.getAllPaymentMethod)
              buildPaymentOption(paymentMethod: paymentMethod)
          ],
        ),
      ],
    );
  }
  Widget buildPaymentOption({required PaymentModel paymentMethod}) {
    final checkoutController = CheckoutController.instance;
    return InkWell(
      onTap: () => checkoutController.updateSelectedPaymentOption(paymentMethod),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
        child: Obx(() => Row(
            children: [
              Radio(
                activeColor: TColors.info,
                value: paymentMethod.id,
                groupValue: checkoutController.selectedPaymentMethod.value.id,
                onChanged: (String? newValue) {
                  checkoutController.updateSelectedPaymentOption(paymentMethod);
                },
              ),
              SizedBox(
                width: 250, // or specify a fixed width if needed
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (paymentMethod.id.isNotEmpty)
                      Image(image: AssetImage(paymentMethod.image ?? ''), fit: BoxFit.contain, height: 25),
                    Text(paymentMethod.description, maxLines: 1, overflow: TextOverflow.ellipsis,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
