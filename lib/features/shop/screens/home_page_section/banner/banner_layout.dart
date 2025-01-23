import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../../../common/widgets/shimmers/shimmer_effect.dart';
import '../../../../../routes/internal_routes.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/banner_controller/banner_controller.dart';
import '../../../models/banner_model.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final bannerController = Get.put(BannerController());
    const double bannerHeight = 200;
    const double bannerWidth = double.infinity;

    return Obx(() {
      //loader
      if(bannerController.isLoading.value) return const ShimmerEffect(height: bannerHeight, width: bannerWidth, radius: 0);

      // check empty
      if(bannerController.banners.isEmpty) {
        // return const Center(child: Text('No data found',style: TextStyle(color: Colors.black)));}
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
                scrollPhysics: const BouncingScrollPhysics(),
                autoPlay: true,
                viewportFraction: 1,
                onPageChanged: (index, _) => bannerController.updatePageIndicator(index)
            ),
            items: bannerController.banners.map((banner) => TRoundedImage(
                  height: bannerHeight,
                  width: bannerWidth,
                  borderRadius: 0,
                  padding: 0,
                  image: banner.imageUrl ?? '',
                  isNetworkImage: true,
                  onTap: () => InternalAppRoutes.internalRouteHandle(url: banner.targetPageUrl ?? ''),
                )
            ).toList(),
          ),
          const SizedBox(height: Sizes.spaceBtwItems),
          Center(
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for(int i = 0; i < bannerController.banners.length; i++)
                      bannerController.carousalCurrentIndex.value == i
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
    });
  }
}
