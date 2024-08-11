import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/sizes.dart';
import '../../models/product_model.dart';

class ImagesController extends GetxController{
  static ImagesController get instance => Get.find();
  late TransformationController controller;
  TapDownDetails? tapDownDetails;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    controller = TransformationController();
  }

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  // show popup image
  void showEnlargedImage (String image) {
    Get.to(
      // fullscreenDialog: true;
      () => Dialog.fullscreen(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: TSizes.defaultSpace * 2, horizontal: TSizes.defaultSpace),
              child: GestureDetector(
                onDoubleTapDown: (details) => tapDownDetails = details,
                onDoubleTap: () {
                  final position = tapDownDetails!.localPosition;
                  const double scale = 3;
                  final x = -position.dx * (scale -1);
                  final y = -position.dy * (scale -1);
                  final zoomed = Matrix4.identity()
                    ..translate(x, y)
                    ..scale(scale);
                  final value = controller.value.isIdentity() ? zoomed : Matrix4.identity();
                  controller.value = value;
                },
                child: InteractiveViewer(
                  maxScale: 3,
                  minScale: 1,
                  transformationController: controller,
                  child: CachedNetworkImage(imageUrl: image)
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSection),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 150,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Close'),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}