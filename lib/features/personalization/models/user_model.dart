import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/constants/db_constants.dart';
import '../../../utils/formatters/formatters.dart';
import 'address_model.dart';

//for woocommerce
class CustomerModel {
  final int? id;
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  String? role;
  String? username;
  AddressModel? billing;
  AddressModel? shipping;
  bool? isPayingCustomer;
  String? avatarUrl;
  String? dateCreated;
  bool? isPhoneVerified;
  String? fCMToken;

  CustomerModel({
    this.id,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.role,
    this.username,
    this.billing,
    this.shipping,
    this.isPayingCustomer,
    this.avatarUrl,
    this.dateCreated,
    this.isPhoneVerified,
    this.fCMToken,
  });

  static CustomerModel empty() => CustomerModel();
  String get name => '${firstName ?? ''} ${lastName ?? ''}';
  String get phone => billing?.phone ?? '';

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    // Extracting meta_data list
    List<dynamic> metaDataList = json['meta_data'] ?? [];

    // Parsing the meta_data to find specific keys
    String fCMToken = '';
    bool isPhoneVerified = false;

    for (var metaData in metaDataList) {
      if (metaData['key'] == CustomerMetaDataName.fCMToken) {
        fCMToken = metaData['value'] ?? '';
      } else if (metaData['key'] == CustomerMetaDataName.verifyPhone) {
        isPhoneVerified = metaData['value'] ?? '';
      }
    }

    return CustomerModel(
      id: json[CustomerFieldName.id] ?? 0,
      email: json[CustomerFieldName.email] ?? '',
      firstName: json[CustomerFieldName.firstName] ?? '',
      lastName: json[CustomerFieldName.lastName] ?? '',
      role: json[CustomerFieldName.role] ?? '',
      username: json[CustomerFieldName.username] ?? '',
      billing: AddressModel.fromJson(json[CustomerFieldName.billing] ?? {}),
      shipping: AddressModel.fromJson(json[CustomerFieldName.shipping] ?? {}),
      isPayingCustomer: json[CustomerFieldName.isPayingCustomer] ?? false,
      avatarUrl: json[CustomerFieldName.avatarUrl] ?? '',
      dateCreated: json[CustomerFieldName.dateCreated] ?? '',
      isPhoneVerified: isPhoneVerified,
      fCMToken: fCMToken,
    );
  }

  Map<String, dynamic> toJsonForWooSingUp(){
    return {
      CustomerFieldName.firstName: firstName,
      CustomerFieldName.username: username,
      CustomerFieldName.email: email,
      CustomerFieldName.password: password,
      CustomerFieldName.billing: billing?.toJsonForWoo(),
      CustomerFieldName.shipping: shipping?.toJsonForWoo(),
    };
  }
}

class CustomerMedaDataModel{
  final int? id;
  final String? key;
  final String? value;

  CustomerMedaDataModel({
    this.id,
    this.key,
    this.value,
  });

  //Convert a cartItem to a Json map
  Map<String, dynamic> toJsonForWoo() {
    return {
      OrderMetaDataName.key: key ?? '',
      OrderMetaDataName.value: value ?? '',
    };
  }
}

class UserModel {

  String? activeTime;
  String? avatarUrl;
  DateTime? dateCreated;
  DateTime? dateModified;
  String? email;
  String? userId;
  bool? isPayingCustomer;
  String? name;
  String? password;
  String  phone;
  String? role;
  Map<String, dynamic>? metaData;
  List<dynamic>? cartItems;
  List<dynamic>? wishlistItems;
  List<dynamic>? recentItems;
  List<dynamic>? customerOrders;

  ///Constructor for UserModel.
  UserModel({
    this.activeTime,
    this.avatarUrl,
    this.dateCreated,
    this.dateModified,
    this.email,
    this.userId,
    this.isPayingCustomer,
    this.name,
    this.password,
    required this.phone,
    this.role,
    this.metaData,
    this.cartItems,
    this.wishlistItems,
    this.recentItems,
    this.customerOrders,
  });

  ///Helper function to Format phone number
  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phone);

  /// static function to create an empty user model.
  static UserModel empty() => UserModel(phone: '');

  ///Covert model to json structure for storing data in FireStore.
  Map<String, dynamic> toJson() {
    // Create metaData map with cartItems, wishlistItems, and recentItems
    Map<String, dynamic> metaData = {
      UserFieldName.cartItems: {
        UserFieldName.items: cartItems,
        UserFieldName.dateModified: Timestamp.now().toDate(),
      },
      UserFieldName.wishlistItems: {
        UserFieldName.items: wishlistItems,
        UserFieldName.dateModified: Timestamp.now().toDate(),
      },
      UserFieldName.recentItems: {
        UserFieldName.items: recentItems,
        UserFieldName.dateModified: Timestamp.now().toDate(),
      },
      UserFieldName.customerOrders: {
        UserFieldName.items: customerOrders,
        UserFieldName.dateModified: Timestamp.now().toDate(),
      },
    };

    return {
      UserFieldName.activeTime: activeTime,
      UserFieldName.avatarUrl: avatarUrl,
      UserFieldName.dateCreated: dateCreated,
      UserFieldName.dateModified: dateModified,
      UserFieldName.email: email,
      UserFieldName.userId: userId,
      UserFieldName.isPayingCustomer: isPayingCustomer,
      UserFieldName.name: name,
      // UserFieldName.password: password,
      UserFieldName.phone: phone,
      UserFieldName.role: role,
      UserFieldName.metaData: metaData,
    };
  }
  // Factory method to create a UserModel from a Firebase document snapshot.
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data != null) {
      return UserModel(
        activeTime: data[UserFieldName.activeTime] ?? '',
        avatarUrl: data[UserFieldName.avatarUrl] ?? '',
        dateCreated: (data[AddressFieldName.dateCreated] as Timestamp?)?.toDate() ?? DateTime(2000),
        dateModified: (data[AddressFieldName.dateModified] as Timestamp?)?.toDate() ?? DateTime(2000),
        email: data[UserFieldName.email] ?? '',
        userId: data[UserFieldName.userId] ?? '',
        isPayingCustomer: data[UserFieldName.isPayingCustomer] ?? false,
        name: data[UserFieldName.name] ?? '',
        // password: data[UserFieldName.password] ?? '',
        phone: data[UserFieldName.phone] ?? '',
        role: data[UserFieldName.role] ?? '',
      );
    } else {
      return UserModel.empty();
    }
  }


}







