import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../../common/widgets/shimmers/shimmer_effect.dart';
import '../../../../common/widgets/shimmers/user_shimmer.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../authentication/screens/check_login_screen/check_login_screen.dart';
import '../../../settings/app_settings.dart';
import '../../controllers/user_controller.dart';
import '../user_profile/user_profile.dart';
import 'widgets/contact_widget.dart';
import 'widgets/follow_us.dart';
import 'widgets/menu.dart';
import 'widgets/policy_widget.dart';
import 'widgets/favourite_with_cart.dart';

class UserMenuScreen extends StatelessWidget {
  const UserMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('user_menu_screen');

    final userController = Get.put(UserController());
    userController.refreshCustomer();

    return  Scaffold(
        appBar: const TAppBar2(titleText: 'Menu', seeLogoutButton: true),
        body: RefreshIndicator(
                color: TColors.refreshIndicator,
                onRefresh: () async => userController.refreshCustomer(),
                child: SingleChildScrollView(
                  padding: TSpacingStyle.defaultPageVertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                       if(AuthenticationRepository.instance.isUserLogin.value) {
                         return Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             // User profile
                             Heading(title: 'Your profile', paddingLeft: Sizes.defaultSpace),
                             CustomerProfileCard(userController: userController),
                           ],
                         );
                       } else {
                         return SizedBox.shrink();
                        }
                      }),

                      // Menu
                      Heading(title: 'Menu', paddingLeft: Sizes.defaultSpace),
                      const Menu(),

                      // Contact
                      Heading(title: 'Support', paddingLeft: Sizes.defaultSpace),
                      const SupportWidget(),

                      // Policy
                      Heading(title: 'Support', paddingLeft: Sizes.defaultSpace),
                      const PolicyWidget(),
                      const SizedBox(height: Sizes.spaceBtwInputFields),

                      // Follow us
                      Heading(title: 'Follow us', paddingLeft: Sizes.defaultSpace),
                      const FollowUs(),
                      const SizedBox(height: Sizes.spaceBtwInputFields),

                      // Version
                      Center(
                        child: Stack(
                          alignment: Alignment.topCenter, // Align text closer to the image
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: Sizes.xs),
                              child: TRoundedImage(
                                  backgroundColor: Colors.transparent,
                                  width: 120,
                                  padding: 0,
                                  image: Theme.of(context).brightness != Brightness.dark
                                      ? AppSettings.lightAppLogo
                                      : AppSettings.lightAppLogo,
                              ),
                            ),
                            Positioned(
                                bottom: 0, // Adjust this to bring text closer
                                child: Obx(() => Text('v${userController.appVersion.value}', style: TextStyle(fontSize: 12),))
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: Sizes.md),
                    ],
                  ),
                ),
            ),
      );
  }
}

class CustomerProfileCard extends StatelessWidget {
  const CustomerProfileCard({
    super.key,
    required this.userController,
  });

  final UserController userController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          if(userController.isLoading.value){
            return const UserTileShimmer();
          } else {
             return InkWell(
               onTap: () => Get.to(() => const UserProfileScreen()),
               child: ListTile(
                  leading: SizedBox(
                    width: 40, height: 40,
                    child:  ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: Obx((){
                        final networkImage = userController.customer.value.avatarUrl;
                        final image = networkImage?.isNotEmpty == true ? networkImage! : Images.tProfileImage; // Using safe null access
                        if (userController.imageUploading.value) {
                          return const ShimmerEffect(width: 50, height: 50);
                        } else {
                          if (networkImage?.isNotEmpty == true) { // Checking null safety
                            return CachedNetworkImage(
                              // fit: BoxFit.cover,
                              // color: Colors.grey,
                              imageUrl: image,
                              progressIndicatorBuilder: (context, url, downloadProgress) => const ShimmerEffect(width: 55, height: 55),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            );
                          } else {
                            return Image(image: AssetImage(image)); // Using safe null access
                          }
                        }
                    })
                ),
                  ),
                  title: Text(userController.customer.value.name.isEmpty ? "User" : userController.customer.value.name,),
                  subtitle: Text(userController.customer.value.email?.isNotEmpty ?? false ? userController.customer.value.email! : '',),
                  trailing: Icon(Icons.arrow_forward_ios, size: 20,),
               ),
             );
          }
        }),
      ],
    );
  }
}






