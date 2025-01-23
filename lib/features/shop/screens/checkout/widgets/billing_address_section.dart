import 'package:aramarket/common/widgets/shimmers/order_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/text/section_heading.dart';
import '../../../../personalization/controllers/user_controller.dart';
import '../../../../personalization/models/address_model.dart';
import '../../../../personalization/screens/user_address/address_widgets/single_address.dart';
import '../../../../personalization/screens/user_address/update_user_address.dart';

class TBillingAddressSection extends StatelessWidget {
  const TBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {

    final userController = Get.put(UserController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TSectionHeading(title: 'Shipping Address'),
        Obx(() {
          if(userController.isLoading.value) {
            return const OrderShimmer(itemCount: 1, height: 150,);
          } else {
            return TSingleAddress(
              address: userController.customer.value.billing ?? AddressModel.empty(),
              onTap: () => Get.to(() => UpdateAddressScreen(
                  title: 'Update Billing Address',
                  address: userController.customer.value.billing ?? AddressModel.empty()
              )),
            );
          }
        }),
      ],
    );
  }
}
