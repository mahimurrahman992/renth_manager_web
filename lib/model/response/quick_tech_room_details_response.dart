import 'package:renth_manager/consts/consts.dart';

class QuicktechRoomDetails {
  QuicktechRoomDetails({this.message, this.propertyRoom});

  String? message;
  PropertyRoom? propertyRoom;

  factory QuicktechRoomDetails.fromJson(Map<String, dynamic> json) {
    return QuicktechRoomDetails(
      message: parseString(json["message"]),
      propertyRoom:
          json["property_room"] == null
              ? null
              : PropertyRoom.fromJson(json["property_room"]),
    );
  }
}

class PropertyRoom {
  PropertyRoom({
    this.id,
    this.discountPricePerNight,
    this.extraMattressPricePerNight,
    this.extraPricePerAdult,
    this.extraPricePerChildBed,
    this.vatPercentage,
    this.serviceCharge,
    this.managerId,
    this.propertyId,
    this.roomTypeId,
    this.bedTypeId,
    this.roomName,
    this.roomPricePerNight,
    this.capacityOfAdults,
    this.capacityOfChildren,
    this.roomSize,
    this.roomDescription,
    this.numberOfRoom,
    this.video,
    this.status,
    this.checkOut,
    this.createdAt,
    this.updatedAt,
    this.roomImages,
    this.facilities,
    this.bedType,
    this.roomType,
  });

  int? id;
  String? discountPricePerNight;
  String? extraMattressPricePerNight;
  String? extraPricePerAdult;
  String? extraPricePerChildBed;
  int? vatPercentage;
  String? serviceCharge;
  int? managerId;
  int? propertyId;
  int? roomTypeId;
  int? bedTypeId;
  String? roomName;
  String? roomPricePerNight;
  int? capacityOfAdults;
  int? capacityOfChildren;
  String? roomSize;
  String? roomDescription;
  int? numberOfRoom;
  dynamic video;
  int? status;
  dynamic checkOut;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<RoomImage>? roomImages;
  List<Facility>? facilities;
  BedType? bedType;
  RoomType? roomType;

  factory PropertyRoom.fromJson(Map<String, dynamic> json) {
    return PropertyRoom(
      id: parseInt(json["id"]),
      discountPricePerNight: parseString(json["discount_price_per_night"]),
      extraMattressPricePerNight: parseString(
        json["extra_mattress_price_per_night"],
      ),
      extraPricePerAdult: parseString(json["extra_price_per_adult"]),
      extraPricePerChildBed: parseString(json["extra_price_per_child_bed"]),
      vatPercentage: parseInt(json["vat_percentage"]),
      serviceCharge: parseString(json["service_charge"]),
      managerId: parseInt(json["manager_id"]),
      propertyId: parseInt(json["property_id"]),
      roomTypeId: parseInt(json["room_type_id"]),
      bedTypeId: parseInt(json["bed_type_id"]),
      roomName: parseString(json["room_name"]),
      roomPricePerNight: parseString(json["room_price_per_night"]),
      capacityOfAdults: parseInt(json["capacity_of_adults"]),
      capacityOfChildren: parseInt(json["capacity_of_children"]),
      roomSize: parseString(json["room_size"]),
      roomDescription: parseString(json["room_description"]),
      numberOfRoom: parseInt(json["number_of_room"]),
      video: json["video"],
      status: parseInt(json["status"]),
      checkOut: json["check_out"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      roomImages:
          json["room_images"] == null
              ? []
              : List<RoomImage>.from(
                json["room_images"]!.map((x) => RoomImage.fromJson(x)),
              ),
      facilities:
          json["facilities"] == null
              ? []
              : List<Facility>.from(
                json["facilities"]!.map((x) => Facility.fromJson(x)),
              ),
      bedType:
          json["bed_type"] == null ? null : BedType.fromJson(json["bed_type"]),
      roomType:
          json["room_type"] == null
              ? null
              : RoomType.fromJson(json["room_type"]),
    );
  }
}

class Facility {
  Facility({
    this.id,
    this.name,
    this.iconClass,
    this.facilityPhoto,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  int? id;
  String? name;
  String? iconClass;
  String? facilityPhoto;
  DateTime? createdAt;
  DateTime? updatedAt;
  Pivot? pivot;

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: parseInt(json["id"]),
      name: parseString(json["name"]),
      iconClass: parseString(json["icon_class"]),
      facilityPhoto: parseString(json["facility_photo"]),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
    );
  }
}

class Pivot {
  Pivot({this.propertyRoomId, this.facilityId});

  int? propertyRoomId;
  int? facilityId;

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      propertyRoomId: parseInt(json["property_room_id"]),
      facilityId: parseInt(json["facility_id"]),
    );
  }
}

class BedType {
  BedType({this.id, this.name, this.createdAt, this.updatedAt});

  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory BedType.fromJson(Map<String, dynamic> json) {
    return BedType(
      id: parseInt(json["id"]),
      name: parseString(json["name"]),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }
}

class RoomImage {
  RoomImage({
    this.id,
    this.propertyRoomId,
    this.photoName,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? propertyRoomId;
  String? photoName;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory RoomImage.fromJson(Map<String, dynamic> json) {
    return RoomImage(
      id: parseInt(json["id"]),
      propertyRoomId: parseInt(json["property_room_id"]),
      photoName: parseString(json["photo_name"]),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }
}

class RoomType {
  RoomType({
    this.id,
    this.name,
    this.totalRoom,
    this.bookedRoom,
    this.availableRoom,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  int? totalRoom;
  int? bookedRoom;
  int? availableRoom;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory RoomType.fromJson(Map<String, dynamic> json) {
    return RoomType(
      id: parseInt(json["id"]),
      name: parseString(json["name"]),
      totalRoom: parseInt(json["total_room"]),
      bookedRoom: parseInt(json["booked_room"]),
      availableRoom: parseInt(json["available_room"]),
      status: parseString(json["status"]),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }
}
