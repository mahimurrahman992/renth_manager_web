import 'package:renth_manager/consts/consts.dart';

class PropertyDetailsModel {
  final String? message;
  final Property? property;

  PropertyDetailsModel({
    this.message,
    this.property,
  });

  PropertyDetailsModel.fromJson(Map<String, dynamic> json)
      : message = parseString(json['message']),
        property = json['property'] != null
            ? Property.fromJson(json['property'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'message': message,
        'property': property?.toJson()
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
  final PropertyCategory? propertyCategory;
  final Upazilas? upazila;
  final Districts? district;
  final List<Rooms>? rooms;
  final List<Amenities>? amenities;
  final List<RentPackages>? rentPackages;
  final List<RentTerms>? rentTerms;
  final List<PropertyRules>? propertyRules;
  final Divisions? division;
  final List<MultiImages>? multiImages;
  final Manager? manager;

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
    this.propertyCategory,
    this.upazila,
    this.district,
    this.rooms,
    this.amenities,
    this.rentPackages,
    this.rentTerms,
    this.propertyRules,
    this.division,
    this.multiImages,
    this.manager,
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
        updatedAt = parseString(json['updated_at']),
        propertyCategory = json['property_category'] != null
            ? PropertyCategory.fromJson(
                json['property_category'] as Map<String, dynamic>)
            : null,
        upazila = json['upazila'] != null
            ? Upazilas.fromJson(json['upazila'] as Map<String, dynamic>)
            : null,
        district = json['district'] != null
            ? Districts.fromJson(json['district'] as Map<String, dynamic>)
            : null,
        rooms = (json['rooms'] as List<dynamic>?)
            ?.map((e) => Rooms.fromJson(e as Map<String, dynamic>))
            .toList(),
        amenities = (json['amenities'] as List<dynamic>?)
            ?.map((e) => Amenities.fromJson(e as Map<String, dynamic>))
            .toList(),
        rentPackages = (json['rent_packages'] as List<dynamic>?)
            ?.map((e) => RentPackages.fromJson(e as Map<String, dynamic>))
            .toList(),
        rentTerms = (json['rent_terms'] as List<dynamic>?)
            ?.map((e) => RentTerms.fromJson(e as Map<String, dynamic>))
            .toList(),
        propertyRules = (json['property_rules'] as List<dynamic>?)
            ?.map((e) => PropertyRules.fromJson(e as Map<String, dynamic>))
            .toList(),
        division = json['division'] != null
            ? Divisions.fromJson(json['division'] as Map<String, dynamic>)
            : null,
        multiImages = (json['multi_images'] as List<dynamic>?)
            ?.map((e) => MultiImages.fromJson(e as Map<String, dynamic>))
            .toList(),
        manager = json['manager'] != null
            ? Manager.fromJson(json['manager'] as Map<String, dynamic>)
            : null;

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
        'updated_at': updatedAt,
        'property_category': propertyCategory?.toJson(),
        'upazila': upazila?.toJson(),
        'district': district?.toJson(),
        'rooms': rooms?.map((e) => e.toJson()).toList(),
        'amenities': amenities?.map((e) => e.toJson()).toList(),
        'rent_packages': rentPackages?.map((e) => e.toJson()).toList(),
        'rent_terms': rentTerms?.map((e) => e.toJson()).toList(),
        'property_rules': propertyRules?.map((e) => e.toJson()).toList(),
        'division': division?.toJson(),
        'multi_images': multiImages?.map((e) => e.toJson()).toList(),
        'manager': manager?.toJson()
      };
}

class PropertyCategory {
  final int? id;
  final String? name;
  final String? categoryPhoto;
  final String? platformFee;
  final String? createdAt;
  final String? updatedAt;

  PropertyCategory({
    this.id,
    this.name,
    this.categoryPhoto,
    this.platformFee,
    this.createdAt,
    this.updatedAt,
  });

  PropertyCategory.fromJson(Map<String, dynamic> json)
      : id = parseInt(json['id']),
        name = parseString(json['name']),
        categoryPhoto = parseString(json['category_photo']),
        platformFee = parseString(json['platform_fee']),
        createdAt = parseString(json['created_at']),
        updatedAt = parseString(json['updated_at']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category_photo': categoryPhoto,
        'platform_fee': platformFee,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}

class Rooms {
  final int? id;
  final String? propertyId;
  final String? shareType;
  final String? price;
  final String? tenant;
  final String? createdAt;
  final String? updatedAt;

  Rooms({
    this.id,
    this.propertyId,
    this.shareType,
    this.price,
    this.tenant,
    this.createdAt,
    this.updatedAt,
  });

  Rooms.fromJson(Map<String, dynamic> json)
      : id = parseInt(json['id']),
        propertyId = parseString(json['property_id']),
        shareType = parseString(json['share_type']),
        price = parseString(json['price']),
        tenant = parseString(json['tenant']),
        createdAt = parseString(json['created_at']),
        updatedAt = parseString(json['updated_at']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'property_id': propertyId,
        'share_type': shareType,
        'price': price,
        'tenant': tenant,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}

class Amenities {
  final int? id;
  final String? propertyId;
  final String? amenityType;
  final String? amenityName;
  final String? createdAt;
  final String? updatedAt;

  Amenities({
    this.id,
    this.propertyId,
    this.amenityType,
    this.amenityName,
    this.createdAt,
    this.updatedAt,
  });

  Amenities.fromJson(Map<String, dynamic> json)
      : id = parseInt(json['id']),
        propertyId = parseString(json['property_id']),
        amenityType = parseString(json['amenity_type']),
        amenityName = parseString(json['amenity_name']),
        createdAt = parseString(json['created_at']),
        updatedAt = parseString(json['updated_at']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'property_id': propertyId,
        'amenity_type': amenityType,
        'amenity_name': amenityName,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}

class RentPackages {
  final int? id;
  final String? propertyId;
  final String? name;
  final String? price;
  final String? createdAt;
  final String? updatedAt;

  RentPackages({
    this.id,
    this.propertyId,
    this.name,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  RentPackages.fromJson(Map<String, dynamic> json)
      : id = parseInt(json['id']),
        propertyId = parseString(json['property_id']),
        name = parseString(json['name']),
        price = parseString(json['price']),
        createdAt = parseString(json['created_at']),
        updatedAt = parseString(json['updated_at']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'property_id': propertyId,
        'name': name,
        'price': price,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}

class RentTerms {
  final int? id;
  final String? propertyId;
  final String? name;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  RentTerms({
    this.id,
    this.propertyId,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  RentTerms.fromJson(Map<String, dynamic> json)
      : id = parseInt(json['id']),
        propertyId = parseString(json['property_id']),
        name = parseString(json['name']),
        description = parseString(json['description']),
        createdAt = parseString(json['created_at']),
        updatedAt = parseString(json['updated_at']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'property_id': propertyId,
        'name': name,
        'description': description,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}

class PropertyRules {
  final int? id;
  final String? propertyId;
  final String? ruleName;
  final String? createdAt;
  final String? updatedAt;

  PropertyRules({
    this.id,
    this.propertyId,
    this.ruleName,
    this.createdAt,
    this.updatedAt,
  });

  PropertyRules.fromJson(Map<String, dynamic> json)
      : id = parseInt(json['id']),
        propertyId = parseString(json['property_id']),
        ruleName = parseString(json['rule_name']),
        createdAt = parseString(json['created_at']),
        updatedAt = parseString(json['updated_at']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'property_id': propertyId,
        'rule_name': ruleName,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}

class MultiImages {
  final int? id;
  final String? propertyId;
  final String? photoName;
  final String? createdAt;
  final String? updatedAt;

  MultiImages({
    this.id,
    this.propertyId,
    this.photoName,
    this.createdAt,
    this.updatedAt,
  });

  MultiImages.fromJson(Map<String, dynamic> json)
      : id = parseInt(json['id']),
        propertyId = parseString(json['property_id']),
        photoName = parseString(json['photo_name']),
        createdAt = parseString(json['created_at']),
        updatedAt = parseString(json['updated_at']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'property_id': propertyId,
        'photo_name': photoName,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}

class Manager {
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
  final dynamic createdAt;
  final String? updatedAt;

  Manager({
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

  Manager.fromJson(Map<String, dynamic> json)
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
        createdAt = json['created_at'],
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