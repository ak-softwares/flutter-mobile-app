import 'package:aramarket/features/personalization/controllers/user_controller.dart';
import 'package:aramarket/features/shop/screens/products/product_detail.dart';
import 'package:aramarket/utils/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/dialog_box/dialog_massage.dart';
import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/web_view/my_web_view.dart';
import '../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../common/widgets/product/product_cards/product_card_cart_items.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../../utils/constants/icons.dart';
import '../../../../utils/constants/local_storage_constants.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/order_helper.dart';
import '../../../authentication/screens/check_login_screen/check_login_screen.dart';
import '../../../personalization/models/address_model.dart';
import '../../../personalization/screens/user_address/address_widgets/single_address.dart';
import '../../../settings/app_settings.dart';
import '../../controllers/cart_controller/cart_controller.dart';
import '../../controllers/order/order_controller.dart';
import '../../models/order_model.dart';

class SingleOrderScreen extends StatefulWidget {
  const SingleOrderScreen({super.key, this.order, this.orderId});

  final String? orderId;
  final OrderModel? order;

  @override
  State<SingleOrderScreen> createState() => _SingleOrderScreenState();
}

class _SingleOrderScreenState extends State<SingleOrderScreen> {
  final localStorage = GetStorage();
  final cartController = Get.put(CartController());
  final orderController = Get.put(OrderController());
  final authenticationRepository = Get.put(AuthenticationRepository());
  final userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    // Initialize product
    orderController.fetchOrder(order: widget.order,  orderId: widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('order_single_screen');
    return Scaffold(
      appBar: TAppBar2(titleText: "Order #${orderController.currentOrder.value.id ?? ''}", showBackArrow: true, showSearchIcon: true, showCartIcon: true,),
      body: !authenticationRepository.isUserLogin.value
          ? const CheckLoginScreen()
          : RefreshIndicator(
        color: AppColors.refreshIndicator,
        onRefresh: () async => orderController.getOrderById(orderId: orderController.currentOrder.value.id.toString()),
        child: Obx(() {
          if(orderController.isLoading.value){
            return Center(child: CircularProgressIndicator(strokeWidth: 3 ));
          } else if(orderController.currentOrder.value.id == null) {
            return Center(child: Text('Sorry! No Order Fount'));
          } else if(orderController.currentOrder.value.customerId != userController.customer.value.id) {
            return Center(child: Text('Sorry! Invalid order'));
          } else{
            final currentOrder = orderController.currentOrder.value;
            return ListView(
              padding: TSpacingStyle.defaultPageVertical,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Column(
                  spacing: Sizes.spaceBtwSection,
                  children: [
                    // Order Items
                    Column(
                      spacing: Sizes.spaceBtwItems,
                      children: [
                        Heading(
                            title: 'Order Items',
                            paddingLeft: Sizes.defaultSpace),
                        GridLayout(
                          crossAxisCount: 1,
                          mainAxisExtent: 90,
                          itemCount: currentOrder.lineItems!.length,
                          itemBuilder: (_, index) => Stack(children: [
                            ProductCardForCart(
                                cartItem: currentOrder.lineItems![index]),
                          ]),
                        ),
                      ],
                    ),

                    // Order Detail Section
                    Padding(
                      padding: TSpacingStyle.defaultPageHorizontal,
                      child: Column(
                        children: [
                          Heading(
                            title: 'Order Details',
                            paddingLeft: Sizes.md,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Order'),
                              Text('#${currentOrder.id}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total'),
                              Text(AppSettings.appCurrencySymbol +
                                  currentOrder.total!),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Status'),
                              Text(currentOrder.status?.prettyName ?? ''),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Date'),
                              Text(currentOrder.formattedOrderDate),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Billing Section
                    Column(
                      children: [
                        Heading(title: 'Billing & address'),
                        SizedBox(
                          height: Sizes.sm,
                        ),
                        TSingleAddress(
                          address: currentOrder.billing ?? AddressModel.empty(),
                          onTap: () {},
                          hideEdit: true,
                        ),
                        SizedBox(height: Sizes.sm),
                        Padding(
                          padding: TSpacingStyle.defaultPageHorizontal,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Subtotal'),
                                  Text(
                                      '${AppSettings.appCurrencySymbol}${currentOrder.calculateTotalSum()}'),
                                ],
                              ),
                              if (currentOrder.discountTotal != '0' &&
                                  currentOrder.discountTotal!.isNotEmpty)
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Discount'),
                                        Text(
                                            '- ${AppSettings.appCurrencySymbol}${currentOrder.discountTotal!}'),
                                      ],
                                    ),
                                  ],
                                ),
                              if (currentOrder.shippingTotal != '0' &&
                                  currentOrder.shippingTotal!.isNotEmpty)
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Shipping'),
                                        Text(AppSettings.appCurrencySymbol +
                                            currentOrder.shippingTotal!),
                                      ],
                                    ),
                                  ],
                                ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  Text(
                                      AppSettings.appCurrencySymbol +
                                          currentOrder.total!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Payment Method  ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  // Text(order.paymentMethodTitle ?? '', style: Theme.of(context).textTheme.bodyMedium),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          currentOrder.paymentMethodTitle ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
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
                        // Pay Now
                        if (TOrderHelper.checkOrderStatusForPayment(
                            currentOrder.status ?? OrderStatus.unknown))
                          Column(
                            children: [
                              ListTile(
                                tileColor:
                                Theme.of(context).colorScheme.surface,
                                onTap: () =>
                                    orderController.makePayment(order: currentOrder),
                                title: Text('Pending Payment'),
                                trailing: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Sizes
                                              .md), // Removes default padding
                                    ),
                                    onPressed: () => orderController
                                        .makePayment(order: currentOrder),
                                    child: Text('Pay Now')),
                              ),
                              Container(
                                height: 1,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ],
                          ),

                        // Buy it again
                        ListTile(
                          tileColor: Theme.of(context).colorScheme.surface,
                          onTap: () => cartController
                              .repeatOrder(currentOrder.lineItems ?? []),
                          title: Text('Buy it again'),
                          trailing: Obx(() => cartController.isLoading.value
                              ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.linkColor,
                              ))
                              : Icon(Icons.arrow_forward_ios, size: 20)),
                        ),
                        Container(
                          height: 1,
                          color: Theme.of(context).colorScheme.outline,
                        ),

                        // Track Package
                        ListTile(
                          tileColor: Theme.of(context).colorScheme.surface,
                          onTap: () => Get.to(() => MyWebView(
                              title: 'Track Order #${currentOrder.id}',
                              url: APIConstant.wooTrackingUrl +
                                  currentOrder.id.toString())),
                          title: Text('Track Package'),
                          trailing: Icon(Icons.open_in_new,
                              size: 20, color: Colors.blue),
                        ),
                        Container(
                          height: 1,
                          color: Theme.of(context).colorScheme.outline,
                        ),

                        // Write product review
                        ListTile(
                            tileColor: Theme.of(context).colorScheme.surface,
                            onTap: () => Get.to(() => ProductScreen(
                                productId: currentOrder.lineItems?[0].productId
                                    .toString())),
                            title: Text('Write a product review'),
                            trailing:
                            Icon(Icons.arrow_forward_ios, size: 20)),
                        Container(
                          height: 1,
                          color: Theme.of(context).colorScheme.outline,
                        ),

                        // Cancel Order
                        if (TOrderHelper.checkOrderStatusForReturn(currentOrder.status ?? OrderStatus.unknown))
                          ListTile(
                            tileColor:
                            Theme.of(context).colorScheme.surface,
                            onTap: () => DialogHelper.showDialog(
                              title: 'Cancel Order',
                              message:
                              'Are you sure you want to cancel this currentOrder?',
                              toastMessage: 'Order cancel Successfully',
                              actionButtonText: 'Cancel',
                              function: () async {
                                await orderController
                                    .cancelOrder(currentOrder.id.toString());
                              },
                              context: context,
                            ),
                            title: Text('Cancel Order'),
                            trailing: Icon(Icons.cancel_outlined,
                                size: 20, color: Colors.red),
                          ),
                      ],
                    )
                  ],
                ),
              ],
            );
          }
        }),
      )
    );
  }
}
