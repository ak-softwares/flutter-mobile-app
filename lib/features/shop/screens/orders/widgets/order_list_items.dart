import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/db_constants.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/order_helper.dart';
import '../../../models/order_model.dart';
import '../single_order_screen.dart';
import 'cancel_order.dart';
import 'order_image_gallery.dart';
import 'repeat_order.dart';
import 'track_now.dart';

class TOrderListItems extends StatelessWidget {
  const TOrderListItems({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      showBorder: true,
      padding: TSpacingStyle.defaultPagePadding,
      borderColor: TColors.borderPrimary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Iconsax.tag),
                    Text('  #${order.id}', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16, fontWeight: FontWeight.w500)),
                    IconButton(
                        icon: const Icon(Icons.copy, size: 20,),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: order.id.toString()));
                          // You might want to show a snackbar or toast to indicate successful copy
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Order Id copied')),
                          );
                        },
                    )
                  ],
                ),
                IconButton(
                    onPressed: () => Get.to(() => SingleOrderScreen(order: order)),
                    icon: const Icon(Iconsax.arrow_right_34, size: TSizes.iconSm,)
                )
              ],
            ),
          ),
          const Divider(color: TColors.borderSecondary),
          Row(
            children: [
              Row(
                children: [
                  const Icon(Iconsax.calendar),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Text(
                    'Order Date',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Text(
                    order.formattedOrderDate,//order.formattedOrderDate,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: TSizes.sm),
          Row(
            children: [
              Text('Shipment status - ', style: Theme.of(context).textTheme.bodyMedium,),
              const SizedBox(width: TSizes.sm),
              TOrderHelper.mapOrderStatus(order.status ?? '')
            ],
          ),
          OrderImageGallery(order: order, galleryImageHeight: 60),
          const Divider(color: TColors.borderSecondary),
          TOrderHelper.checkOrderStatusForReturn(order.status ?? '')
          ? CancelOrderWidget(orderId: order.id.toString())
          : TOrderHelper.checkOrderStatusForInTransit(order.status ?? '')
              ? TrackOrderWidget(orderId: order.id.toString())
              : RepeatOrderWidget(cartItems: order.lineItems ?? []),
        ],
      ),
    );
  }
}
