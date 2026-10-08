import 'package:renth_manager/consts/consts.dart';

class PropertyResponse {
  final String? message;
  final Property? property;
  final List<Room>? rooms;
  final List<Amenity>? amenities;
  final List<RentPackage>? rentPackages;
  final List<RentTerm>? rentTerms;
  final List<PropertyRule>? propertyRules;
  final List<MultiImage>? multiImages;

  PropertyResponse({
    this.message,
    this.property,
    this.rooms,
    this.amenities,
    this.rentPackages,
    this.rentTerms,
    this.propertyRules,
    this.multiImages,
  });

  PropertyResponse.fromJson(Map<String, dynamic> json)
      : message = parseString(json['message']),
        property = json['property'] != null
            ? Property.fromJson(json['property'] as Map<String, dynamic>)
            : null,
        rooms = (json['rooms'] as List<dynamic>?)
            ?.map((e) => Room.fromJson(e as Map<String, dynamic>))
            .toList(),
        amenities = (json['amenities'] as List<dynamic>?)
            ?.map((e) => Amenity.fromJson(e as Map<String, dynamic>))
            .toList(),
        rentPackages = (json['rent_packages'] as List<dynamic>?)
            ?.map((e) => RentPackage.fromJson(e as Map<String, dynamic>))
            .toList(),
        rentTerms = (json['rent_terms'] as List<dynamic>?)
            ?.map((e) => RentTerm.fromJson(e as Map<String, dynamic>))
            .toList(),
        propertyRules = (json['property_rules'] as List<dynamic>?)
            ?.map((e) => PropertyRule.fromJson(e as Map<String, dynamic>))
            .toList(),
        multiImages = (json['multi_images'] as List<dynamic>?)
            ?.map((e) => MultiImage.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'message': message,
        'property': property?.toJson(),
        'rooms': rooms?.map((v) => v.toJson()).toList(),
        'amenities': amenities?.map((v) => v.toJson()).toList(),
        'rent_packages': rentPackages?.map((v) => v.toJson()).toList(),
        'rent_terms': rentTerms?.map((v) => v.toJson()).toList(),
        'property_rules': propertyRules?.map((v) => v.toJson()).toList(),
        'multi_images': multiImages?.map((v) => v.toJson()).toList(),
      };

  // Helper methods for better usability
  bool get isSuccess => message?.toLowerCase().contains('success') ?? false;

  int get totalRooms => rooms?.length ?? 0;

  int get totalImages => multiImages?.length ?? 0;

  int get totalAmenities => amenities?.length ?? 0;

  int get totalPackages => rentPackages?.length ?? 0;

  List<Room> getRoomsByType(String type) {
    return rooms
            ?.where((room) =>
                room.shareType?.toLowerCase() == type.toLowerCase())
            .toList() ??
        [];
  }

  List<Amenity> getAmenitiesByType(String type) {
    return amenities
            ?.where((amenity) =>
                amenity.type?.toLowerCase() == type.toLowerCase())
            .toList() ??
        [];
  }
}

class Property {
  final int? id;
  final String? title;
  final String? aboutProperty;
  final String? totalPrice;
  final String? divisionId;
  final String? districtId;
  final String? upazillaId;
  final String? gender;
  final String? residentType;
  final String? address;
  final String? mapEmbedCode;
  final String? ownerName;
  final String? aboutOwner;
  final int? userId;
  final String? propertyCategoryId;
  final String? createdAt;
  final String? updatedAt;

  Property({
    this.id,
    this.title,
    this.aboutProperty,
    this.totalPrice,
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
    this.propertyCategoryId,
    this.createdAt,
    this.updatedAt,
  });

  Property.fromJson(Map<String, dynamic> json)
      : id = parseInt(json['id']),
        title = parseString(json['title']),
        aboutProperty = parseString(json['about_property']),
        totalPrice = parseString(json['total_price']),
        divisionId = parseString(json['division_id']),
        districtId = parseString(json['district_id']),
        upazillaId = parseString(json['upazilla_id']),
        gender = parseString(json['gender']),
        residentType = parseString(json['resident_type']),
        address = parseString(json['address']),
        mapEmbedCode = parseString(json['map_embed_code']),
        ownerName = parseString(json['owner_name']),
        aboutOwner = parseString(json['about_owner']),
        userId = parseInt(json['user_id']),
        propertyCategoryId = parseString(json['property_category_id']),
        createdAt = parseString(json['created_at']),
        updatedAt = parseString(json['updated_at']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'about_property': aboutProperty,
        'total_price': totalPrice,
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
        'property_category_id': propertyCategoryId,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}

class Room {
  final int? id;
  final String? propertyId;
  final String? shareType;
  final String? price;
  final String? tenant;
  final String? createdAt;
  final String? updatedAt;

  Room({
    this.id,
    this.propertyId,
    this.shareType,
    this.price,
    this.tenant,
    this.createdAt,
    this.updatedAt,
  });

  Room.fromJson(Map<String, dynamic> json)
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

class Amenity {
  final int? id;
  final String? propertyId;
  final String? type;
  final String? name;
  final String? createdAt;
  final String? updatedAt;

  Amenity({
    this.id,
    this.propertyId,
    this.type,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  Amenity.fromJson(Map<String, dynamic> json)
      : id = parseInt(json['id']),
        propertyId = parseString(json['property_id']),
        type = parseString(json['type']),
        name = parseString(json['name']),
        createdAt = parseString(json['created_at']),
        updatedAt = parseString(json['updated_at']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'property_id': propertyId,
        'type': type,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}

class RentPackage {
  final int? id;
  final String? propertyId;
  final String? name;
  final String? price;
  final String? createdAt;
  final String? updatedAt;

  RentPackage({
    this.id,
    this.propertyId,
    this.name,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  RentPackage.fromJson(Map<String, dynamic> json)
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

class RentTerm {
  final int? id;
  final String? propertyId;
  final String? name;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  RentTerm({
    this.id,
    this.propertyId,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  RentTerm.fromJson(Map<String, dynamic> json)
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

class PropertyRule {
  final int? id;
  final String? propertyId;
  final String? rule;
  final String? createdAt;
  final String? updatedAt;

  PropertyRule({
    this.id,
    this.propertyId,
    this.rule,
    this.createdAt,
    this.updatedAt,
  });

  PropertyRule.fromJson(Map<String, dynamic> json)
      : id = parseInt(json['id']),
        propertyId = parseString(json['property_id']),
        rule = parseString(json['rule']),
        createdAt = parseString(json['created_at']),
        updatedAt = parseString(json['updated_at']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'property_id': propertyId,
        'rule': rule,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}

class MultiImage {
  final int? id;
  final String? propertyId;
  final String? imagePath;
  final String? createdAt;
  final String? updatedAt;

  MultiImage({
    this.id,
    this.propertyId,
    this.imagePath,
    this.createdAt,
    this.updatedAt,
  });

  MultiImage.fromJson(Map<String, dynamic> json)
      : id = parseInt(json['id']),
        propertyId = parseString(json['property_id']),
        imagePath = parseString(json['image_path']),
        createdAt = parseString(json['created_at']),
        updatedAt = parseString(json['updated_at']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'property_id': propertyId,
        'image_path': imagePath,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}