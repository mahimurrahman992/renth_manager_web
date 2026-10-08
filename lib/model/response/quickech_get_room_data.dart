class QuicktechgetroomDataResponse {
  QuicktechgetroomDataResponse({
    required this.message,
    required this.facilities,
    required this.bedTypes,
    required this.roomTypes,
    required this.properties,
  });

  final String? message;
  final List<Faciliti> facilities;
  final List<Type> bedTypes;
  final List<Type> roomTypes;
  final List<Properties> properties;

  factory QuicktechgetroomDataResponse.fromJson(Map<String, dynamic> json) {
    return QuicktechgetroomDataResponse(
      message: json["message"],
      facilities:
          json["facilities"] == null
              ? []
              : List<Faciliti>.from(
                json["facilities"]!.map((x) => Faciliti.fromJson(x)),
              ),
      bedTypes:
          json["bed_types"] == null
              ? []
              : List<Type>.from(
                json["bed_types"]!.map((x) => Type.fromJson(x)),
              ),
      roomTypes:
          json["room_types"] == null
              ? []
              : List<Type>.from(
                json["room_types"]!.map((x) => Type.fromJson(x)),
              ),
      properties:
          json["properties"] == null
              ? []
              : List<Properties>.from(
                json["properties"]!.map((x) => Properties.fromJson(x)),
              ),
    );
  }
}

class Type {
  Type({required this.id, required this.name});

  final int? id;
  final String? name;

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(id: json["id"], name: json["name"]);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Type && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Faciliti {
  Faciliti({required this.id, required this.name, required this.facilityPhoto});

  final int? id;
  final String? name;
  final String? facilityPhoto;

  factory Faciliti.fromJson(Map<String, dynamic> json) {
    return Faciliti(
      id: json["id"],
      name: json["name"],
      facilityPhoto: json["facility_photo"],
    );
  }
}

class Properties {
  Properties({
    required this.id,
    required this.title,
    required this.propertyCategoryId,
    required this.propertyCategory,
  });

  final int? id;
  final String? title;
  final int? propertyCategoryId;
  final PropertyCategory? propertyCategory;

  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
      id: json["id"],
      title: json["title"],
      propertyCategoryId: json["property_category_id"],
      propertyCategory:
          json["property_category"] == null
              ? null
              : PropertyCategory.fromJson(json["property_category"]),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Properties && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class PropertyCategory {
  PropertyCategory({
    required this.id,
    required this.name,
    required this.categoryPhoto,
    required this.platformFee,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? name;
  final String? categoryPhoto;
  final int? platformFee;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory PropertyCategory.fromJson(Map<String, dynamic> json) {
    return PropertyCategory(
      id: json["id"],
      name: json["name"],
      categoryPhoto: json["category_photo"],
      platformFee: json["platform_fee"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }
}
