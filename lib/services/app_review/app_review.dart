import 'package:in_app_review/in_app_review.dart';

class AppReview {
  static Future<void> showReviewPopup() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      // Optional: fallback to open store listing
      inAppReview.openStoreListing(
        // appStoreId: 'YOUR_APP_STORE_ID',     // For iOS
        // microsoftStoreId: 'YOUR_STORE_ID',   // For Windows (if needed)
      );
    }
  }

}