import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/image_strings.dart';
import '../../../controllers/banner_controller/banner_controller.dart';


class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  State<ImageSlider> createState() => _ImageSlider();
}

class _ImageSlider extends State<ImageSlider> {

  final controller = Get.put(BannerController());

  List<Map<String, dynamic>> imageList = [
    {"id": 1, "imagePath": TImages.banner1},
    {"id": 2, "imagePath": TImages.banner2},
    {"id": 3, "imagePath": TImages.banner2},
  ];
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            InkWell(
              onTap: () {
                // print(currentIndex);
              },
              // child: CarouselSlider(
              //
              //   items: TRoundedContainer.CarouselController.banners.map((banner) =>
              //     Image.asset(
              //       banner.imageUrl,
              //       fit: BoxFit.cover,
              //       width: double.infinity,
              //   )).toList(),
              //   carouselController: carouselController,
              //   options: CarouselOptions(
              //     scrollPhysics: const BouncingScrollPhysics(),
              //     autoPlay: true,
              //     aspectRatio: 2,
              //     viewportFraction: 1,
              //     height: 180,
              //     onPageChanged: (index, reason){
              //       setState(() {
              //         currentIndex = index;
              //       });
              //     }
              //   ),
              // ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imageList.asMap().entries.map((entry) {
                  // print(entry);
                  // print(entry.key);
                  return GestureDetector(
                    onTap: () => carouselController.animateToPage(entry.key),
                    child: Container(
                      width: currentIndex == entry.key ? 7 : 5,
                      height: currentIndex == entry.key ? 7 : 5,
                      // height: 7.0,
                      margin: const EdgeInsets.symmetric(horizontal: 3.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: currentIndex == entry.key
                          ? Colors.yellow
                          : Colors.teal
                      ),
                    ),
                  );
                }).toList(),
              )
            )
          ],
        )
      ],
    );
  }
}

