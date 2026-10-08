import 'package:renth_manager/consts/consts.dart';

class PropertyListModel {
  final String? message;
  final List<Properties>? properties;

  PropertyListModel({
    this.message,
    this.properties,
  });

  PropertyListModel.fromJson(Map<String, dynamic> json)
      : message = parseString(json['message']),
        properties = (json['properties'] as List<dynamic>?)
            ?.map((e) => Properties.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'message': message,
        'properties': properties?.map((e) => e.toJson()).toList()
      };
}

class Properties {
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
  final Upazila? upazila;
  final District? district;
  final List<Rooms>? rooms;

  Properties({
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
    this.upazila,
    this.district,
    this.rooms,
  });

  /// Override equality operator to compare Properties by ID
  /// This fixes the DropdownButton assertion error
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Properties &&
          runtimeType == other.runtimeType &&
          id == other.id;

  /// Override hashCode to match the equality operator
  @override
  int get hashCode => id.hashCode;

  Properties.fromJson(Map<String, dynamic> json)
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
        upazila = json['upazila'] != null
            ? Upazila.fromJson(json['upazila'] as Map<String, dynamic>)
            : null,
        district = json['district'] != null
            ? District.fromJson(json['district'] as Map<String, dynamic>)
            : null,
        rooms = (json['rooms'] as List<dynamic>?)
            ?.map((e) => Rooms.fromJson(e as Map<String, dynamic>))
            .toList();

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
        'upazila': upazila?.toJson(),
        'district': district?.toJson(),
        'rooms': rooms?.map((e) => e.toJson()).toList()
      };
}

class Upazila {
  final int? id;
  final String? districtId;
  final String? name;
  final String? bnName;
  final String? url;
  final dynamic createdAt;
  final dynamic updatedAt;

  Upazila({
    this.id,
    this.districtId,
    this.name,
    this.bnName,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  Upazila.fromJson(Map<String, dynamic> json)
      : id = parseInt(json['id']),
        districtId = parseString(json['district_id']),
        name = parseString(json['name']),
        bnName = parseString(json['bn_name']),
        url = parseString(json['url']),
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'district_id': districtId,
        'name': name,
        'bn_name': bnName,
        'url': url,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}

class District {
  final int? id;
  final String? divisionId;
  final String? name;
  final String? bnName;
  final String? lat;
  final String? lon;
  final String? url;

  District({
    this.id,
    this.divisionId,
    this.name,
    this.bnName,
    this.lat,
    this.lon,
    this.url,
  });

  District.fromJson(Map<String, dynamic> json)
      : id = parseInt(json['id']),
        divisionId = parseString(json['division_id']),
        name = parseString(json['name']),
        bnName = parseString(json['bn_name']),
        lat = parseString(json['lat']),
        lon = parseString(json['lon']),
        url = parseString(json['url']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'division_id': divisionId,
        'name': name,
        'bn_name': bnName,
        'lat': lat,
        'lon': lon,
        'url': url
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