import 'package:aramarket/features/shop/screens/products/product_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../common/dialog_box/dialog_massage.dart';
import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/web_view/my_web_view.dart';
import '../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../common/widgets/product/product_cards/product_card_cart_items.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../../utils/constants/icons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/order_helper.dart';
import '../../../personalization/models/address_model.dart';
import '../../../personalization/screens/user_address/address_widgets/single_address.dart';
import '../../../settings/app_settings.dart';
import '../../controllers/cart_controller/cart_controller.dart';
import '../../controllers/order/order_controller.dart';
import '../../models/order_model.dart';

class SingleOrderScreen extends StatelessWidget {
  const SingleOrderScreen({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('order_single_screen');
    final cartController = Get.put(CartController());
    final orderController = Get.put(OrderController());

    return Scaffold(
      appBar: TAppBar2(titleText: "Order #${order.id}", showBackArrow: true, showSearchIcon: true, showCartIcon: true,),
      body: SingleChildScrollView(
        padding: TSpacingStyle.defaultPageVertical,
        child: Column(
          spacing: Sizes.spaceBtwSection,
          children: [
            // Order Items
            Column(
              spacing: Sizes.spaceBtwItems,
              children: [
                Heading(title: 'Order Items', paddingLeft: Sizes.defaultSpace),
                GridLayout(
                  crossAxisCount: 1,
                  mainAxisExtent: 90,
                  itemCount: order.lineItems!.length,
                  itemBuilder: (_, index) => Stack(
                      children:[
                        ProductCardForCart(cartItem: order.lineItems![index]),
                      ]
                  ),
                ),
              ],
            ),

            // Order Detail Section
            Padding(
              padding: TSpacingStyle.defaultPageHorizontal,
              child: Column(
                children: [
                  Heading(title: 'Order Details', paddingLeft: Sizes.md,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order'),
                      Text('#${order.id}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total'),
                      Text(AppSettings.appCurrencySymbol + order.total!),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Status'),
                      Text(order.status ?? ''),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Date'),
                      Text(order.formattedOrderDate),
                    ],
                  ),
                ],
              ),
            ),

            // Billing Section
            Column(
              children: [
                Heading(title: 'Billing & address'),
                SizedBox(height: Sizes.sm,),
                TSingleAddress(address: order.billing ?? AddressModel.empty(), onTap: () {}, hideEdit: true,),
                SizedBox(height: Sizes.sm),
                Padding(
                  padding: TSpacingStyle.defaultPageHorizontal,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal'),
                          Text('${AppSettings.appCurrencySymbol}${order.calculateTotalSum()}'),
                        ],
                      ),
                      if(order.discountTotal != '0' && order.discountTotal!.isNotEmpty)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Discount'),
                                Text('- ${AppSettings.appCurrencySymbol}${order.discountTotal!}'),
                              ],
                            ),
                          ],
                        ),
                      if(order.shippingTotal != '0' && order.shippingTotal!.isNotEmpty)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Shipping'),
                                Text(AppSettings.appCurrencySymbol + order.shippingTotal!),
                              ],
                            ),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: TextStyle(fontWeight: FontWeight.w500)),
                          Text(AppSettings.appCurrencySymbol + order.total!, style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Payment Method  ', style: Theme.of(context).textTheme.bodyMedium),
                          // Text(order.paymentMethodTitle ?? '', style: Theme.of(context).textTheme.bodyMedium),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(order.paymentMethodTitle ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Track order section
            Column(
              children: [
                // Buy it again
                ListTile(
                  tileColor: Theme.of(context).colorScheme.surface,
                  onTap: () => cartController.repeatOrder(order.lineItems ?? []),
                  title: Text('Buy it again'),
                  trailing: Obx(() =>
                  cartController.isLoading.value
                      ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: TColors.linkColor,))
                      : Icon(Icons.arrow_forward_ios, size: 20)
                  ),
                ),

                Container(
                  height: 1,
                  color: Theme.of(context).colorScheme.outline,
                ),
                // Track Package
                ListTile(
                  tileColor: Theme.of(context).colorScheme.surface,
                  onTap: () => Get.to(() => MyWebView(title: 'Track Order #${order.id}', url: APIConstant.wooTrackingUrl + order.id.toString())),
                  title: Text('Track Package'),
                  trailing: Icon(Icons.open_in_new, size: 20, color: Colors.blue),
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).colorScheme.outline,
                ),

                // Cancel Order
                TOrderHelper.checkOrderStatusForReturn(order.status ?? '')
                    ? Column(
                      children: [
                        ListTile(
                            tileColor: Theme.of(context).colorScheme.surface,
                            onTap: () => DialogHelper.showDialog(
                              title: 'Cancel Order',
                              message: 'Are you sure you want to cancel this order?',
                              toastMessage: 'Order cancel Successfully',
                              actionButtonText: 'Cancel',
                              function: () async {
                                await orderController.cancelOrder(order.id.toString());
                              },
                              context: context,
                            ),
                            title: Text('Cancel Order'),
                            trailing: Icon(Icons.cancel_outlined, size: 20, color: Colors.red),
                          ),
                        Container(
                          height: 1,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ],
                    )
                    : const SizedBox.shrink(),

                // Write product review
                ListTile(
                    tileColor: Theme.of(context).colorScheme.surface,
                    onTap: () => Get.to(() => ProductDetailScreen(productId: order.lineItems?[0].productId.toString())),
                    title: Text('Write a product review'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 20)
                ),
              ],
            )
          ],
        )
      )
    );
  }
}
