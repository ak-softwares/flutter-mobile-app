import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../../../routes/internal_routes.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/banner_controller/banner_controller.dart';
import '../../../models/banner_model.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannerController());
    const double bannerHeight = 200;
    const double bannerWidth = double.infinity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            scrollPhysics: const BouncingScrollPhysics(),
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 6), // Set autoplay time here
            viewportFraction: 1,
            onPageChanged: (index, _) => controller.updatePageIndicator(index),
          ),
          items: BannerController.assetImagePaths.map((map) {
            // Create a BannerModel instance for each map
            final banner = BannerModel(
              imageUrl: map['imagePath']!,
              targetScreen: map['targetScreen']!,
            );

            return TRoundedImage(
              height: bannerHeight,
              width: bannerWidth,
              borderRadius: 0,
              padding: 0,
              image: banner.imageUrl,
              isNetworkImage: false,
              // onTap: () => InternalAppRoutes.internalRouteHandle(url: banner.targetScreen ?? ''),
              onTap: () {
                InternalAppRoutes.internalRouteHandle(url: banner.targetScreen ?? '');
              },
            );
          }).toList(),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Center(
          child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for(int i = 0; i < BannerController.assetImagePaths.length; i++)
                controller.carousalCurrentIndex.value == i
                    ? const TRoundedContainer(
                  width: 20,
                  height: 4,
                  margin: EdgeInsets.only(right: 6),
                  backgroundColor: TColors.primaryColor,
                )
                    : const TRoundedContainer(
                  width: 10,
                  height: 4,
                  margin: EdgeInsets.only(right: 6),
                  backgroundColor: TColors.secondaryColor,
                )
            ],
          )
          ),
        )
      ],
    );

    // return Obx(() {
    //   //loader
    //   if(controller.isLoading.value) return const TShimmerEffect(height: bannerHeight, width: bannerWidth, radius: 0);
    //
    //   // check empty
    //   if(controller.banners.isEmpty) {
    //     // return const Center(child: Text('No data found',style: TextStyle(color: Colors.black)));}
    //     return const SizedBox.shrink();
    //   }
    //
    //   return Column(
    //     children: [
    //       CarouselSlider(
    //         options: CarouselOptions(
    //             scrollPhysics: const BouncingScrollPhysics(),
    //             autoPlay: true,
    //             viewportFraction: 1,
    //             onPageChanged: (index, _) => controller.updatePageIndicator(index)
    //         ),
    //         items: controller.banners.map((banner) => TRoundedImage(
    //               height: bannerHeight,
    //               width: bannerWidth,
    //               borderRadius: 0,
    //               padding: 0,
    //               image: banner.imageUrl,
    //               isNetworkImage: false,
    //               onTap: () => Get.toNamed(banner.targetScreen!),
    //             )
    //         ).toList(),
    //       ),
    //       const SizedBox(height: TSizes.spaceBtwItems),
    //       Center(
    //         child: Obx(() => Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 for(int i = 0; i < controller.banners.length; i++)
    //                   controller.carousalCurrentIndex.value == i
    //                     ? const TRoundedContainer(
    //                         width: 20,
    //                         height: 4,
    //                         margin: EdgeInsets.only(right: 6),
    //                         backgroundColor: TColors.primaryColor,
    //                       )
    //                     : const TRoundedContainer(
    //                         width: 10,
    //                         height: 4,
    //                         margin: EdgeInsets.only(right: 6),
    //                         backgroundColor: TColors.secondaryColor,
    //                       )
    //               ],
    //             )
    //         ),
    //       )
    //     ],
    //   );
    // });
  }
}
