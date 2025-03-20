// List of forms
// they can not be define in a class

import 'db_constants.dart';

enum TextSizes { small, medium, large}

enum OrderStatus {
  cancelled,
  processing,
  readyToShip,
  pendingPickup,
  pendingPayment,
  inTransit,
  completed,
  returnInTransit,
  returnPending,
  unknown
}

extension OrderStatusExtension on OrderStatus {
  String get name {
    switch (this) {
      case OrderStatus.cancelled:
        return OrderStatusName.cancelled;
      case OrderStatus.processing:
        return OrderStatusName.processing;
      case OrderStatus.readyToShip:
        return OrderStatusName.readyToShip;
      case OrderStatus.pendingPayment:
        return OrderStatusName.pendingPayment;
      case OrderStatus.pendingPickup:
        return OrderStatusName.pendingPickup;
      case OrderStatus.inTransit:
        return OrderStatusName.inTransit;
      case OrderStatus.completed:
        return OrderStatusName.completed;
      case OrderStatus.returnInTransit:
        return OrderStatusName.returnInTransit;
      case OrderStatus.returnPending:
        return OrderStatusName.returnPending;
      case OrderStatus.unknown:
        return OrderStatusName.unknown;
    }
  }

  String get prettyName {
    switch (this) {
      case OrderStatus.cancelled:
        return OrderStatusPritiName.cancelled;
      case OrderStatus.processing:
        return OrderStatusPritiName.processing;
      case OrderStatus.readyToShip:
        return OrderStatusPritiName.readyToShip;
      case OrderStatus.pendingPickup:
        return OrderStatusPritiName.pendingPickup;
      case OrderStatus.pendingPayment:
        return OrderStatusPritiName.pendingPayment;
      case OrderStatus.inTransit:
        return OrderStatusPritiName.inTransit;
      case OrderStatus.completed:
        return OrderStatusPritiName.completed;
      case OrderStatus.returnInTransit:
        return OrderStatusPritiName.returnInTransit;
      case OrderStatus.returnPending:
        return OrderStatusPritiName.returnPending;
      case OrderStatus.unknown:
        return OrderStatusName.unknown;
    }
  }

  static OrderStatus fromString(String status) {
    return OrderStatus.values.firstWhere((orderStatus) {
        return orderStatus.name == status; // Ensure this returns a boolean
      },
      orElse: () => OrderStatus.unknown, // Handle unknown statuses
    );
  }
}

enum PaymentMethods {
  cod,
  prepaid,
  paytm,
  razorpay,
}

extension PaymentMethodsExtension on PaymentMethods {
  String get name {
    switch (this) {
      case PaymentMethods.cod:
        return PaymentMethodName.cod;
      case PaymentMethods.prepaid:
        return PaymentMethodName.prepaid;
      case PaymentMethods.paytm:
        return PaymentMethodName.paytm;
      case PaymentMethods.razorpay:
        return PaymentMethodName.razorpay;
    }
  }

  String get title {
    switch (this) {
      case PaymentMethods.cod:
        return PaymentMethodTitle.cod;
      case PaymentMethods.prepaid:
        return PaymentMethodTitle.prepaid;
      case PaymentMethods.paytm:
        return PaymentMethodTitle.paytm;
      case PaymentMethods.razorpay:
        return PaymentMethodTitle.razorpay;
    }
  }

  String get description {
    switch (this) {
      case PaymentMethods.cod:
        return PaymentMethodDescription.cod;
      case PaymentMethods.prepaid:
        return PaymentMethodDescription.prepaid;
      case PaymentMethods.paytm:
        return PaymentMethodDescription.paytm;
      case PaymentMethods.razorpay:
        return PaymentMethodDescription.razorpay;
    }
  }

  static PaymentMethods fromString(String method) {
    return PaymentMethods.values.firstWhere(
          (e) => e.name == method,
      orElse: () => PaymentMethods.cod, // Default to COD if unknown
    );
  }
}


