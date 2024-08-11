import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/widgets/shimmers/shimmer_effect.dart';
import '../../../../common/widgets/shimmers/user_shimmer.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../authentication/screens/check_login_screen/check_login_screen.dart';
import '../../controllers/user_controller.dart';
import '../profile/profile.dart';
import 'widgets/contact_widget.dart';
import 'widgets/follow_us.dart';
import 'widgets/menu.dart';
import 'widgets/policy_widget.dart';
import 'widgets/wishlist_with_cart.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    userController.refreshCustomer();

    return  Obx(() => Scaffold(
        backgroundColor: TColors.secondaryBackground,
        appBar: const TAppBar2(titleText: 'Profile Setting', seeLogoutButton: true,),
        body: !AuthenticationRepository.instance.isUserLogin.value
            ? const CheckLoginScreen()
            : RefreshIndicator(
                color: TColors.refreshIndicator,
                onRefresh: () async => userController.refreshCustomer(),
                child: SingleChildScrollView(
                  padding: TSpacingStyle.defaultPagePadding,
                  child: Column(
                    children: [
                      //User profile
                      CustomerProfileCard(userController: userController, showHeading: true),

                      //Cart and wishlist
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      const WishlistWithCart(),

                      //Menu
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      const Menu(),

                      //Contact
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      const SupportWidget(showHeading: true),

                      //Policy
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      const PolicyWidget(),

                      //Follow us
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      const FollowUs(),
                    ],
                  ),
                ),
            ),
      ),
    );
  }
}

class CustomerProfileCard extends StatelessWidget {
  const CustomerProfileCard({
    super.key,
    required this.userController, this.showHeading = false,
  });

  final bool showHeading;
  final UserController userController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TColors.primaryBackground,
      width: double.infinity,
      padding: TSpacingStyle.defaultPagePadding,
      child: Column(
        children: [
          showHeading
            ? Column(
                children: [
                  TSectionHeading(title: 'Your profile', verticalPadding: false, seeActionButton: true, buttonTitle: '', onPressed: () => Get.to(() => const ProfileScreen()),),
                  const Divider(color: TColors.primaryColor, thickness: 2,),
                ],
              )
            : const SizedBox.shrink(),
          Obx(() {
            if(userController.isLoading.value){
              return const UserTileShimmer();
            } else {
               return ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: SizedBox(
                    width: 50, height: 50,
                    child:  ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: Obx((){
                        final networkImage = userController.customer.value.avatarUrl;
                        final image = networkImage?.isNotEmpty == true ? networkImage! : TImages.tProfileImage; // Using safe null access
                        if (userController.imageUploading.value) {
                          return const TShimmerEffect(width: 50, height: 50);
                        } else {
                          if (networkImage?.isNotEmpty == true) { // Checking null safety
                            return CachedNetworkImage(
                              // fit: BoxFit.cover,
                              // color: Colors.grey,
                              imageUrl: image,
                              progressIndicatorBuilder: (context, url, downloadProgress) => const TShimmerEffect(width: 55, height: 55),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            );
                          } else {
                            return Image(image: AssetImage(image)); // Using safe null access
                          }
                        }
                    })
                ),
                  ),
                  title: Text(userController.customer.value.name.isEmpty ? "User" : userController.customer.value.name, style: Theme.of(context).textTheme.titleSmall),
                  subtitle: Text(userController.customer.value.email?.isNotEmpty ?? false ? userController.customer.value.email! : '', style: Theme.of(context).textTheme.bodyMedium),
               );
            }
          }),
        ],
      ),
    );
  }
}






