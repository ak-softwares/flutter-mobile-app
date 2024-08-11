
import 'package:get/get.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../data/repositories/firebase/banners/banner_repository.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../models/banner_model.dart';

class BannerController extends GetxController {

  //variables
  final isLoading = false.obs;
  final carousalCurrentIndex = 0.obs;
  final RxList<BannerModel> banners = <BannerModel>[].obs;

  // List of local asset image paths
  static List<Map<String, String>> assetImagePaths = [
    {
      'imagePath': 'assets/images/banners/1.png',
      'targetScreen': 'https://aramarket.in/product-category/mobile-repairing-tools/',
    },
    {
      'imagePath': 'assets/images/banners/2.png',
      'targetScreen': 'https://aramarket.in/product-category/tv-repairing/',
    },
    {
      'imagePath': 'assets/images/banners/3.png',
      'targetScreen': 'https://aramarket.in/product-category/ac-repairing-tool/',
    },
  ];

  @override
  void onInit() {
    fetchBanners();
    super.onInit();
  }

  //update page navigational Dots
  void updatePageIndicator(index) {
    carousalCurrentIndex.value = index;
  }

  // fetch banner
  // Future<void> fetchBannersLocal() async {
  //   try {
  //     // Show loader while loading banners
  //     isLoading.value = true;
  //
  //     // Loop through the asset image paths
  //     for (String path in assetImagePaths) {
  //       // Load the asset image
  //       ByteData imageData = await rootBundle.load(path);
  //
  //       // Convert the ByteData to Uint8List
  //       List<int> byteList = imageData.buffer.asUint8List();
  //
  //       // Convert the byteList to base64 encoded string
  //       String base64Image = base64Encode(byteList);
  //
  //       // Create a BannerModel instance and add it to the banners list
  //       banners.add(BannerModel(imageUrl: base64Image));
  //     }
  //
  //     // Hide loader after loading banners
  //     isLoading.value = false;
  //   } catch (e) {
  //     // Handle errors
  //     isLoading.value = false;
  //     print('=========$e');
  //   }
  // }
  //fetch banner
  Future<void> fetchBanners() async {
    try {
      /// show loader while loading categories
      isLoading.value = true;

      //fetch Banners from data source(firebase, api, etc)
      final bannerRepo = Get.put(BannerRepository());
      final banners = await bannerRepo.fetchBanners();

      //assign banner
      this.banners.assignAll(banners);

    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error - Banner loading', message: e.toString());
    } finally {
      // remove loading
      isLoading.value = false;
    }
  }

}