
class DbCollections{
  static const String orders      = 'Orders';
  static const String products    = 'Products';
  static const String users       = 'Users';
  static const String categories  = 'Categories';
  static const String banners     = 'Banners';
  static const String addresses   = 'Addresses';
  static const String meta        = 'Meta';
}

class ProductFieldName {
  static const String id = 'id';
  static const String name = 'name';
  static const String permalink = 'permalink';
  static const String slug = 'slug';
  static const String dateCreated = 'date_created';
  static const String type = 'type';
  static const String status = 'status';
  static const String featured = 'featured';
  static const String catalogVisibility = 'catalog_visibility';
  static const String description = 'description';
  static const String shortDescription = 'short_description';
  static const String sku = 'sku';
  static const String price = 'regular_price';
  static const String salePrice = 'price';
  static const String regularPrice = 'regular_price';
  static const String dateOnSaleFrom = 'date_on_sale_from';
  static const String dateOnSaleTo = 'date_on_sale_to';
  static const String onSale = 'on_sale';
  static const String purchasable = 'purchasable';
  static const String totalSales = 'total_sales';
  static const String virtual = 'virtual';
  static const String downloadable = 'downloadable';
  static const String taxStatus = 'tax_status';
  static const String taxClass = 'tax_class';
  static const String manageStock = 'manage_stock';
  static const String stockQuantity = 'stock_quantity';
  static const String weight = 'weight';
  static const String dimensions = 'dimensions';
  static const String shippingRequired = 'shipping_required';
  static const String shippingTaxable = 'shipping_taxable';
  static const String shippingClass = 'shipping_class';
  static const String shippingClassId = 'shipping_class_id';
  static const String reviewsAllowed = 'reviews_allowed';
  static const String averageRating = 'average_rating';
  static const String ratingCount = 'rating_count';
  static const String upsellIds = 'upsell_ids';
  static const String crossSellIds = 'cross_sell_ids';
  static const String parentId = 'parent_id';
  static const String purchaseNote = 'purchase_note';
  static const String categories = 'categories';
  static const String tags = 'tags';
  static const String images = 'images';
  static const String attributes = 'attributes';
  static const String variations = 'variations';
  static const String groupedProducts = 'grouped_products';
  static const String menuOrder = 'menu_order';
  static const String relatedIds = 'related_ids';
  static const String stockStatus = 'stock_status';
}

class ReviewFieldName {
  static const String id = 'id';
  static const String dateCreated = 'date_created';
  static const String productId = 'product_id';
  static const String productName = 'product_name';
  static const String productPermalink = 'product_permalink';
  static const String status = 'status';
  static const String reviewer = 'reviewer';
  static const String reviewerEmail = 'reviewer_email';
  static const String review = 'review';
  static const String rating = 'rating';
  static const String verified = 'verified';
  static const String reviewerAvatarUrls = 'reviewer_avatar_urls';
}

class ProductAttributeFieldName {
  static const String id          = 'id';
  static const String name        = 'name';
  static const String value       = 'value';
}

class CategoryFieldName {
  static const String id          = 'id';
  static const String name        = 'name';
  static const String image       = 'image';
  static const String parentId    = 'parentId';
  static const String isFeatured  = 'isFeatured';
}

class BannerFieldName {
  static const String imageUrl      = 'imageUrl';
  static const String targetScreen  = 'targetScreen';
  static const String active        = 'active';
}

class MetaFieldName {
  static const String userCounter     = 'userCounter';
  static const String orderCounter    = 'orderCounter';
  static const String productCounter  = 'productCounter';
  static const String categoryCounter = 'categoryCounter';
  static const String value           = 'counter';
}

class UserFieldName {
  static const String activeTime          = 'activeTime';
  static const String avatarUrl           = 'avatarUrl';
  static const String dateCreated         = 'dateCreated';
  static const String dateModified        = 'dateModified';
  static const String email               = 'email';
  static const String userId              = 'userId';
  static const String isPayingCustomer    = 'isPayingCustomer';
  static const String name                = 'name';
  static const String password            = 'password';
  static const String phone               = 'phone';
  static const String role                = 'role';
  static const String metaData            = 'metaData';
  static const String cartItems           = 'cartItems';
  static const String wishlistItems       = 'wishlistItems';
  static const String recentItems         = 'recentItems';
  static const String items               = 'items';
  static const String roleCustomer        = 'customer';
  static const String customerOrders      = 'customerOrders';
}

class CustomerFieldName {
  static const String id = 'id';
  static const String email = 'email';
  static const String password = 'password';
  static const String firstName = 'first_name';
  static const String lastName = 'last_name';
  static const String role = 'role';
  static const String username = 'username';
  static const String billing = 'billing';
  static const String shipping = 'shipping';
  static const String isPayingCustomer = 'is_paying_customer';
  static const String avatarUrl = 'avatar_url';
  static const String dateCreated = 'date_created';
}

class CustomerMetaDataName {
  static const String id = 'id';
  static const String key = 'key';
  static const String value = 'value';
  static const String metaData = 'meta_data';
  static const String fCMToken = 'easyapp_fcm_token';
  static const String verifyPhone = 'easyapp_verify_phone';

}

class OrderFieldName {
  static const String id = 'id';
  static const String status = 'status';
  static const String currency = 'currency';
  static const String pricesIncludeTax = 'prices_include_tax';
  static const String dateCreated = 'date_created';
  static const String dateModified = 'date_modified';
  static const String discountTotal = 'discount_total';
  static const String discountTax = 'discount_tax';
  static const String shippingTotal = 'shipping_total';
  static const String shippingTax = 'shipping_tax';
  static const String cartTax = 'cart_tax';
  static const String total = 'total';
  static const String totalTax = 'total_tax';
  static const String customerId = 'customer_id';
  static const String billing = 'billing';
  static const String shipping = 'shipping';
  static const String paymentMethod = 'payment_method';
  static const String paymentMethodTitle = 'payment_method_title';
  static const String transactionId = 'transaction_id';
  static const String customerIpAddress = 'customer_ip_address';
  static const String customerUserAgent = 'customer_user_agent';
  static const String customerNote = 'customer_note';
  static const String dateCompleted = 'date_completed';
  static const String datePaid = 'date_paid';
  static const String number = 'number';
  static const String metaData = 'meta_data';
  static const String lineItems = 'line_items';
  static const String shippingLines = 'shipping_lines';
  static const String couponLines = 'coupon_lines';
  static const String paymentUrl = 'payment_url';
  static const String currencySymbol = 'currency_symbol';
  static const String setPaid = 'set_paid';
}
class OrderMetaDataName {
  static const String id = 'id';
  static const String key = 'key';
  static const String value = 'value';
  static const String metaData = 'meta_data';
}

class OrderStatusName {
  static const String cancelled = 'cancelled';
  static const String processing = 'processing';
  static const String readyToShip = 'readytoship';
  static const String pendingPickup = 'pending-pickup';
  static const String inTransit = 'intransit';
  static const String completed = 'completed';
  static const String returnInTransit = 'returnintransit';
  static const String returnPending = 'returnpending';
}

class OrderStatusPritiName {
  static const String cancelled = 'Cancelled';
  static const String processing = 'Processing';
  static const String readyToShip = 'Ready To Ship';
  static const String pendingPickup = 'Pending Pickup';
  static const String inTransit = 'In-Transit';
  static const String completed = 'Delivered';
  static const String returnInTransit = 'Return In-Transit';
  static const String returnPending = 'Return Pending';
}

class AddressFieldName {
  static const String id = 'id';
  static const String name = 'name';
  static const String firstName = 'first_name';
  static const String lastName = 'last_name';
  static const String phone = 'phone';
  static const String email = 'email';
  static const String address1 = 'address_1';
  static const String address2 = 'address_2';
  static const String company = 'company';
  static const String city = 'city';
  static const String state = 'state';
  static const String pincode = 'postcode';
  static const String country = 'country';
  static const String dateCreated = 'dateCreated';
  static const String dateModified = 'dateModified';
  static const String selectedAddress = 'selectedAddress';
}

class CartFieldName {
  static const String id = 'id';
  static const String name = 'name';
  static const String productId = 'product_id'; // corrected
  static const String variationId = 'variation_id'; // corrected
  static const String quantity = 'quantity';
  static const String subtotal = 'subtotal';
  static const String subtotalTax = 'subtotal_tax'; // corrected
  static const String totalTax = 'total_tax'; // corrected
  static const String total = 'total'; // corrected
  static const String sku = 'sku';
  static const String price = 'price';
  static const String image = 'image';
  static const String src = 'src';
  static const String parentName = 'parent_name'; // corrected
}

class StoragePath{
  static const String productsPath = 'Products/Images/';
  static const String categoryPath = 'Products/Images/';
  static const String userAvtar    = 'Users/Images/Profile/';
}

class CouponFieldName{
  static const String id = 'id';
  static const String code = 'code';
  static const String amount = 'amount';
  static const String dateCreated = 'date_created';
  static const String discountType = 'discount_type';
  static const String description = 'description';
  static const String dateExpires = 'date_expires';
  static const String freeShipping = 'free_shipping';
  static const String individualUse = 'individual_use';
  static const String minimumAmount = 'minimum_amount';
  static const String maximumAmount = 'maximum_amount';

  static const String metaData = 'meta_data';
  static const String paymentMethods = '_wt_sc_payment_methods';
  static const String maxDiscount = '_wt_max_discount';
}

class PaymentFieldName {
  static const String id = 'id';
  static const String title = 'title';
  static const String description = 'description'; // corrected
  static const String image = 'image'; // corrected
  static const String key = 'key'; // corrected
  static const String secret = 'secret'; // corrected
}