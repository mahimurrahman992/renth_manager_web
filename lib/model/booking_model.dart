

import 'package:renth_manager/consts/consts.dart';

class BookingListModel {
  final String? message;
  final List<BookingOrders>? bookingOrders;

  BookingListModel({
    this.message,
    this.bookingOrders,
  });

  BookingListModel.fromJson(Map<String, dynamic> json)
      : message = parseString(json['message']),
        bookingOrders = (json['booking_orders'] as List<dynamic>?)
            ?.map((e) => BookingOrders.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'message': message,
        'booking_orders': bookingOrders?.map((e) => e.toJson()).toList()
      };
}

class BookingOrders {
  final int? id;
  final String? bookingPaymentId;
  final String? userId;
  final String? propertyId;
  final String? managerId;
  final String? managerFee;
  final String? adminFee;
  final String? withdrawRequestStatus;
  final String? managerPaymentStatus;
  final String? createdAt;
  final String? updatedAt;
  final Property? property;
  final Customer? customer;

  BookingOrders({
    this.id,
    this.bookingPaymentId,
    this.userId,
    this.propertyId,
    this.managerId,
    this.managerFee,
    this.adminFee,
    this.withdrawRequestStatus,
    this.managerPaymentStatus,
    this.createdAt,
    this.updatedAt,
    this.property,
    this.customer,
  });

  BookingOrders.fromJson(Map<String, dynamic> json)
      : id = parseInt(json['id']),
        bookingPaymentId = parseString(json['booking_payment_id']),
        userId = parseString(json['user_id']),
        propertyId = parseString(json['property_id']),
        managerId = parseString(json['manager_id']),
        managerFee = parseString(json['manager_fee']),
        adminFee = parseString(json['admin_fee']),
        withdrawRequestStatus = parseString(json['withdraw_request_status']),
        managerPaymentStatus = parseString(json['manager_payment_status']),
        createdAt = parseString(json['created_at']),
        updatedAt = parseString(json['updated_at']),
        property = json['property'] != null
            ? Property.fromJson(json['property'] as Map<String, dynamic>)
            : null,
        customer = json['customer'] != null
            ? Customer.fromJson(json['customer'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'booking_payment_id': bookingPaymentId,
        'user_id': userId,
        'property_id': propertyId,
        'manager_id': managerId,
        'manager_fee': managerFee,
        'admin_fee': adminFee,
        'withdraw_request_status': withdrawRequestStatus,
        'manager_payment_status': managerPaymentStatus,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'property': property?.toJson(),
        'customer': customer?.toJson()
      };
}

class Property {
  final int? id;
  final String? title;
  final String? aboutProperty;
  final String? totalPrice;
  final String? bookingStatus;
  final String? divisionId;
  final String? districtId;
  final String? upazillaId;
  final String? gender;
  final String? residentType;
  final String? address;
  final String? mapEmbedCode;
  final String? ownerName;
  final String? aboutOwner;
  final String? userId;
  final String? status;
  final String? propertyCategoryId;
  final String? createdAt;
  final String? updatedAt;

  Property({
    this.id,
    this.title,
    this.aboutProperty,
    this.totalPrice,
    this.bookingStatus,
    this.divisionId,
    this.districtId,
    this.upazillaId,
    this.gender,
    this.residentType,
    this.address,
    this.mapEmbedCode,
    this.ownerName,
    this.aboutOwner,
    this.userId,
    this.status,
    this.propertyCategoryId,
    this.createdAt,
    this.updatedAt,
  });

  Property.fromJson(Map<String, dynamic> json)
      : id = parseInt(json['id']),
        title = parseString(json['title']),
        aboutProperty = parseString(json['about_property']),
        totalPrice = parseString(json['total_price']),
        bookingStatus = parseString(json['booking_status']),
        divisionId = parseString(json['division_id']),
        districtId = parseString(json['district_id']),
        upazillaId = parseString(json['upazilla_id']),
        gender = parseString(json['gender']),
        residentType = parseString(json['resident_type']),
        address = parseString(json['address']),
        mapEmbedCode = parseString(json['map_embed_code']),
        ownerName = parseString(json['owner_name']),
        aboutOwner = parseString(json['about_owner']),
        userId = parseString(json['user_id']),
        status = parseString(json['status']),
        propertyCategoryId = parseString(json['property_category_id']),
        createdAt = parseString(json['created_at']),
        updatedAt = parseString(json['updated_at']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'about_property': aboutProperty,
        'total_price': totalPrice,
        'booking_status': bookingStatus,
        'division_id': divisionId,
        'district_id': districtId,
        'upazilla_id': upazillaId,
        'gender': gender,
        'resident_type': residentType,
        'address': address,
        'map_embed_code': mapEmbedCode,
        'owner_name': ownerName,
        'about_owner': aboutOwner,
        'user_id': userId,
        'status': status,
        'property_category_id': propertyCategoryId,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}

class Customer {
  final int? id;
  final String? name;
  final String? slug;
  final String? email;
  final String? phone;
  final String? profilePhoto;
  final String? birthday;
  final String? gender;
  final String? address;
  final dynamic emailVerifiedAt;
  final dynamic profileFor;
  final String? activeStatus;
  final String? role;
  final String? profileVisibility;
  final String? interestRequestAccess;
  final String? status;
  final String? type;
  final String? propertyCategoryId;
  final String? createdAt;
  final String? updatedAt;

  Customer({
    this.id,
    this.name,
    this.slug,
    this.email,
    this.phone,
    this.profilePhoto,
    this.birthday,
    this.gender,
    this.address,
    this.emailVerifiedAt,
    this.profileFor,
    this.activeStatus,
    this.role,
    this.profileVisibility,
    this.interestRequestAccess,
    this.status,
    this.type,
    this.propertyCategoryId,
    this.createdAt,
    this.updatedAt,
  });

  Customer.fromJson(Map<String, dynamic> json)
      : id = parseInt(json['id']),
        name = parseString(json['name']),
        slug = parseString(json['slug']),
        email = parseString(json['email']),
        phone = parseString(json['phone']),
        profilePhoto = parseString(json['profile_photo']),
        birthday = parseString(json['birthday']),
        gender = parseString(json['gender']),
        address = parseString(json['address']),
        emailVerifiedAt = json['email_verified_at'], 
        profileFor = json['profile_for'],
        activeStatus = parseString(json['active_status']),
        role = parseString(json['role']),
        profileVisibility = parseString(json['profile_visibility']),
        interestRequestAccess = parseString(json['interest_request_access']),
        status = parseString(json['status']),
        type = parseString(json['type']),
        propertyCategoryId = parseString(json['property_category_id']),
        createdAt = parseString(json['created_at']),
        updatedAt = parseString(json['updated_at']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'email': email,
        'phone': phone,
        'profile_photo': profilePhoto,
        'birthday': birthday,
        'gender': gender,
        'address': address,
        'email_verified_at': emailVerifiedAt,
        'profile_for': profileFor,
        'active_status': activeStatus,
        'role': role,
        'profile_visibility': profileVisibility,
        'interest_request_access': interestRequestAccess,
        'status': status,
        'type': type,
        'property_category_id': propertyCategoryId,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}