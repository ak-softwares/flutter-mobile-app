import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../data/repositories/user/user_repository.dart';
import '../../../../data/repositories/woocommerce_repositories/products/woo_product_repositories.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/local_storage_constants.dart';
import '../../models/cart_item_model.dart';
import '../../models/product_model.dart';
import '../../screens/cart/cart.dart';
import '../product/product_controller.dart';

class CartController extends GetxController{
  static CartController get instance => Get.find();

  // Variables
  RxBool isLoading = false.obs;
  RxBool isCancelLoading = false.obs;
  RxInt noOfCartItems = 0.obs;
  RxDouble totalCartPrice = 0.0.obs;
  RxInt productQuantityInCart = 1.obs;
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;

  List<String> productIdsForCloud = [];
  final localStorage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadCartItems();
  }

  // Add to cart
  void addToCart({required ProductModel product, required int quantity}) {
    try {
      // Quantity Check
      if (quantity < 1) {
        throw 'Select Quantity';
      }
      // Out of stock status
      if (!product.isProductAvailable()) {
        throw 'Selected product is out of stock';
      }
      // Convert the productModel to a cartItemModel with the give quantity
      final selectedCartItem = convertToCartItem(product, quantity);

      //check if item already in cart or not
      int index = cartItems.indexWhere((cartItem) => cartItem.productId == selectedCartItem.productId);
      if (index >= 0) {
        // This quantity is already added or updated/remove from the design
        cartItems[index].quantity = selectedCartItem.quantity;
        cartItems[index].subtotal = (selectedCartItem.quantity * cartItems[index].price!).toStringAsFixed(0);
      } else {
        cartItems.add(selectedCartItem);
      }

      // Log the add to cart event
      FBAnalytics.logAddToCart(cartItem: selectedCartItem);

      //update cart and show success message
      updateCart();
      TLoaders.customToast(message: 'Product added ${selectedCartItem.quantity} product to Cart.');
    } catch(e) {
      TLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
      rethrow;
    }
  }

  // Toggle Cart item
  void toggleCartProduct(ProductModel product) {
    // Convert the productModel to a cartItemModel with the give quantity
    final convertedCartItem = convertToCartItem(product, 1);

    if(!isInCart(product.id)) {
      addToCart(product: product, quantity: 1);
    } else {
      removeFromCart(item: convertedCartItem);
      TLoaders.customToast(message: 'Product removed from the Cart.');
    }
  }

  // Remove item to cart without dialog
  void removeFromCart({required CartItemModel item}) {
    // Log the add to cart event
    FBAnalytics.logRemoveFromCart(cartItem: item);
    int index = cartItems.indexWhere((cartItem) => cartItem.productId == item.productId);
    if(index >= 0) {
      cartItems.removeAt(index);
    }
    updateCart();
  }

  // Show dialog box before removing product
  void removeFromCartDialog(CartItemModel item) {
    Get.defaultDialog(
        title: 'Remove Product',
        middleText: 'Are you sure you want to remove this product?',
        onConfirm: () {
          //remove the item form cart
          removeFromCart(item: item);
          TLoaders.customToast(message: 'Product removed form the cart.');
          Get.back();
        },
        onCancel: () => () => Get.back()
    );
  }

  // Add single item to cart
  void addOneToCart(CartItemModel item) {
    int index = cartItems.indexWhere((cartItem) => cartItem.productId == item.productId);
    if(index >= 0){
      //This quantity is already added or updated/remove from the design
      cartItems[index].quantity += 1;
      cartItems[index].subtotal = (cartItems[index].quantity * cartItems[index].price!).toStringAsFixed(0);
    } else{
      cartItems.add(item);
    }
    updateCart();
  }

  // Remove single item to cart
  void removeOneToCart(CartItemModel item) {
    int index = cartItems.indexWhere((cartItem) => cartItem.productId == item.productId);
    if(index >= 0) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity -= 1;
        cartItems[index].subtotal = (cartItems[index].quantity * cartItems[index].price!).toStringAsFixed(0);
      } else {
        // Show dialog before completely removing
        cartItems[index].quantity == 1 ? removeFromCartDialog(item) : cartItems.removeAt(index);
      }
    }
    updateCart();
  }

  // This function converts a productModel to a cartItemModel
  CartItemModel convertToCartItem(ProductModel product, int quantity) {
    return CartItemModel(
      id: 1,
      name: product.name,
      productId: product.id,
      variationId: 0,
      quantity: quantity,
      category: product.categories?[0].name,
      subtotal: (quantity * product.getPrice()).toStringAsFixed(0),
      subtotalTax: '0',
      totalTax: '0',
      sku: product.sku,
      price: product.getPrice().toInt(),
      image: product.mainImage,
      parentName: '0',
      isCODBlocked: product.isCODBlocked,
    );
  }

  //update cart
  void updateCart() {
    updateCartTotal();
    saveCartItems();
    cartItems.refresh();
  }

  //update cart total
  void updateCartTotal(){
    double calculateTotalPrice = 0.0;
    int calculatedNoOfItems = 0;

    for(var item in cartItems){
      calculateTotalPrice += (item.price!) * item.quantity;
      calculatedNoOfItems += item.quantity;
    }
    totalCartPrice.value = calculateTotalPrice;
    noOfCartItems.value = calculatedNoOfItems;
  }

  //save cart data to local storage
  Future<void> saveCartItems() async {
    final cartItemsStrings = cartItems.map((item) => item.toJson()).toList();
    localStorage.write(LocalStorage.cartItems, cartItemsStrings);

    // final List<String> productIds = cartItems.map((item) => item.productId.toString()).toList();
    // if(!compareLists(productIds, productIdsForCloud)) {
    //   productIdsForCloud = List.from(productIds);
    //   // productIdsForCloud.addAll(List<String>.from(productIds));
    //   await userRepository.updateMetaData(UserFieldName.cartItems, productIds); //save data in Cloud Storage
    // }
  }

  //load cart items from local storage
  Future<void> loadCartItems() async {
    final List<dynamic>? cartItemStrings = localStorage.read(LocalStorage.cartItems);
    if (cartItemStrings != null) {
      List<CartItemModel> cartItemModels = [];

      for (final itemString in cartItemStrings) {
        final Map<String, dynamic> itemJson = itemString as Map<String, dynamic>;
        cartItemModels.add(CartItemModel.fromJsonLocalStorage(itemJson));
      }

      cartItems.assignAll(cartItemModels);
      updateCartTotal();
    }
  }

  // Get cart quantity for a given product
  int getCartQuantity(int productId) {
    // Find the product in the cart items and calculate the total quantity
    final cartQuantity = cartItems
        .where((item) => item.productId == productId)
        .fold(0, (previousValue, element) => previousValue + element.quantity);

    // If no item is found, return 1, otherwise return the calculated quantity
    return cartQuantity <= 0 ? 1 : cartQuantity;
  }

  //clear cart
  void clearCart(){
    productQuantityInCart.value = 0;
    cartItems.clear();
    updateCart();
  }

  // check product is in cart
  bool isInCart(int productId) {
    int index = cartItems.indexWhere((cartItem) => cartItem.productId == productId);
    if(index >= 0){
      return true;
    } else{
      return false;
    }
  }

  Future<void> repeatOrder(List<CartItemModel> selectedCartItems) async {
    try{
      isLoading.value = true; // Show loader
      List<String> productIds = selectedCartItems.map((item) => item.productId.toString()).toList();
      List<ProductModel> products = await WooProductRepository.instance.fetchProductsByIds(productIds: productIds.join(','), page: '1');
      // Add to cart Using forEach method
      for (var product in products) {
        // Find the corresponding CartItemModel
        var cartItem = selectedCartItems.firstWhere((item) => item.productId == product.id,
          orElse: () => CartItemModel(productId: product.id, quantity: 1),
        );
        // Add to cart
        isLoading.value = false; // Show loader
        addToCart(product: product, quantity: cartItem.quantity);
      }
      // cartItems.addAll(selectedCartItems);
      Get.to(() => const CartScreen());
    }catch(error){
      isLoading.value = false; // Show loader
      rethrow;
    }
  }
}