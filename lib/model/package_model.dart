import 'package:renth_manager/consts/consts.dart';

class PackageModel {
  final List<Packages>? packages;
  final PackageOrder? packageOrder;

  PackageModel({
    this.packages,
    this.packageOrder,
  });

  PackageModel.fromJson(Map<String, dynamic> json)
      : packages = (json['packages'] as List<dynamic>?)
            ?.map((e) => Packages.fromJson(e as Map<String, dynamic>))
            .toList(),
        packageOrder = json['package_order'] != null
            ? PackageOrder.fromJson(json['package_order'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'packages': packages?.map((e) => e.toJson()).toList(),
        'package_order': packageOrder?.toJson()
      };
}

class Packages {
  final int? id;
  final String? name;
  final String? popular;
  final String? status;
  final String? price;
  final String? maximumPost;
  final String? duration;
  final String? shortDescription;
  final String? type;
  final dynamic createdAt;
  final String? updatedAt;

  Packages({
    this.id,
    this.name,
    this.popular,
    this.status,
    this.price,
    this.maximumPost,
    this.duration,
    this.shortDescription,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  Packages.fromJson(Map<String, dynamic> json)
      : id = parseInt(json['id']),
        name = parseString(json['name']),
        popular = parseString(json['popular']),
        status = parseString(json['status']),
        price = parseString(json['price']),
        maximumPost = parseString(json['maximum_post']),
        duration = parseString(json['duration']),
        shortDescription = parseString(json['short_description']),
        type = parseString(json['type']),
        createdAt = json['created_at'], // Kept as dynamic since it was defined that way
        updatedAt = parseString(json['updated_at']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'popular': popular,
        'status': status,
        'price': price,
        'maximum_post': maximumPost,
        'duration': duration,
        'short_description': shortDescription,
        'type': type,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}

class PackageOrder {
  final int? id;
  final String? paymentId;
  final String? userId;
  final String? packageId;
  final String? totalPost;
  final String? expiredAt;
  final String? invoiceNo;
  final String? orderDate;
  final String? orderMonth;
  final String? orderYear;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  PackageOrder({
    this.id,
    this.paymentId,
    this.userId,
    this.packageId,
    this.totalPost,
    this.expiredAt,
    this.invoiceNo,
    this.orderDate,
    this.orderMonth,
    this.orderYear,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  PackageOrder.fromJson(Map<String, dynamic> json)
      : id = parseInt(json['id']),
        paymentId = parseString(json['payment_id']),
        userId = parseString(json['user_id']),
        packageId = parseString(json['package_id']),
        totalPost = parseString(json['total_post']),
        expiredAt = parseString(json['expired_at']),
        invoiceNo = parseString(json['invoice_no']),
        orderDate = parseString(json['order_date']),
        orderMonth = parseString(json['order_month']),
        orderYear = parseString(json['order_year']),
        status = parseString(json['status']),
        createdAt = parseString(json['created_at']),
        updatedAt = parseString(json['updated_at']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'payment_id': paymentId,
        'user_id': userId,
        'package_id': packageId,
        'total_post': totalPost,
        'expired_at': expiredAt,
        'invoice_no': invoiceNo,
        'order_date': orderDate,
        'order_month': orderMonth,
        'order_year': orderYear,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}