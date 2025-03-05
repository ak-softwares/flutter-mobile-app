import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/local_storage_constants.dart';

class CacheHelper {
  static List<String> boxes = [
    CacheConstants.bannersBox,
    CacheConstants.brandBox,
    CacheConstants.categoryBox,
    CacheConstants.couponBox,
    CacheConstants.customerBox,
    CacheConstants.orderBox,
    CacheConstants.productReviewBox,
    CacheConstants.productBox,
    CacheConstants.settingsBox,
  ];
  static List<String> openedBoxes = []; // Store opened box names

  // Initialize Hive
  // Initialize Hive
  static Future<void> initializeHive() async {
    try {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path); // Initialize Hive with the app's document directory

      for (String boxName in boxes) {
        if (!Hive.isBoxOpen(boxName)) {
          await Hive.openBox(boxName);
          openedBoxes.add(boxName);
        }
      }

    } catch (e) {
      rethrow;
    }
  }


  // Helper method to check if cached data is expired
  static bool isCacheValid({required Box cacheBox, required String cacheKey, double expiryTimeInDays = 1}) {
    if (!cacheBox.isOpen) return false;

    final now = DateTime.now().millisecondsSinceEpoch;
    final storedTime = cacheBox.get('${cacheKey}_time'); // Time when data was cached

    if (storedTime == null) return false; // No cache time stored, consider invalid

    final expirationTime = storedTime + (expiryTimeInDays * 24 * 60 * 60 * 1000);

    return now < expirationTime;
  }


  // Deletes only the values inside the boxes but keeps the boxes available for future use.
  static Future<void> clearAllCacheBox() async {
    try {
      for (String boxName in openedBoxes) {
        if (Hive.isBoxOpen(boxName)) {
          await Hive.box(boxName).clear();
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> clearCacheBox({required String cacheBoxName}) async {
    try {
      if (!Hive.isBoxOpen(cacheBoxName)) {
        await Hive.openBox(cacheBoxName); // Ensure the box is open before clearing
      }
      await Hive.box(cacheBoxName).clear(); // Clear all values inside the box
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteCacheKey({required String cacheBoxName, required String key}) async {
    try {
      if (!Hive.isBoxOpen(cacheBoxName)) {
        await Hive.openBox(cacheBoxName); // Ensure the box is open before deleting key
      }
      final box = Hive.box(cacheBoxName);
      if (box.containsKey(key)) {
        await box.delete(key); // Delete the specific key
      }
    } catch (e) {
      rethrow;
    }
  }


  // Completely removes all Hive storage, like uninstalling the database.
  static Future<void> deleteHiveFromDisk() async {
    try {
      await Hive.deleteFromDisk();
      openedBoxes.clear(); // Reset opened boxes list
    } catch (e) {
      rethrow;
    }
  }

  // Just closes all open boxes, preventing further reads/writes until reopened.
  static Future<void> closeAllBoxes() async {
    try {
      for (String boxName in openedBoxes) {
        if (Hive.isBoxOpen(boxName)) {
          await Hive.box(boxName).close();
        }
      }
      openedBoxes.clear(); // Clear tracking list after closing
    } catch (e) {
      rethrow;
    }
  }
}
