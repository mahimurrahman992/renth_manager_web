import 'package:renth_manager/consts/consts.dart';

class QuicktechRoomModel {
  String? message;
  List<PropertyRoom>? propertyRooms;

  QuicktechRoomModel({this.message, this.propertyRooms});

  QuicktechRoomModel.fromJson(Map<String, dynamic> json) {
    message = parseString(json["message"]);
    propertyRooms = json["property_rooms"] == null
        ? null
        : (json["property_rooms"] as List)
            .map((e) => PropertyRoom.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["message"] = message;
    if (propertyRooms != null) {
      data["property_rooms"] = propertyRooms?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class PropertyRoom {
  int? id;
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
  String? video;
  int? status;
  int? booked;
  String? createdAt;
  String? updatedAt;
  List<RoomImage>? roomImages;
  List<Facility>? facilities;
  BedType? bedType;
  RoomType? roomType;

  PropertyRoom({
    this.id,
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
    this.booked,
    this.createdAt,
    this.updatedAt,
    this.roomImages,
    this.facilities,
    this.bedType,
    this.roomType,
  });

  PropertyRoom.fromJson(Map<String, dynamic> json) {
    id = parseInt(json["id"]);
    extraPricePerAdult = parseString(json["extra_price_per_adult"]);
    extraPricePerChildBed = parseString(json["extra_price_per_child_bed"]);
    vatPercentage = parseInt(json["vat_percentage"]);
    serviceCharge = parseString(json["service_charge"]);
    managerId = parseInt(json["manager_id"]);
    propertyId = parseInt(json["property_id"]);
    roomTypeId = parseInt(json["room_type_id"]);
    bedTypeId = parseInt(json["bed_type_id"]);
    roomName = parseString(json["room_name"]);
    roomPricePerNight = parseString(json["room_price_per_night"]);
    capacityOfAdults = parseInt(json["capacity_of_adults"]);
    capacityOfChildren = parseInt(json["capacity_of_children"]);
    roomSize = parseString(json["room_size"]);
    roomDescription = parseString(json["room_description"]);
    numberOfRoom = parseInt(json["number_of_room"]);
    video = parseString(json["video"]);
    status = parseInt(json["status"]);
    booked = parseInt(json["booked"]);
    createdAt = parseString(json["created_at"]);
    updatedAt = parseString(json["updated_at"]);
    roomImages = json["room_images"] == null
        ? null
        : (json["room_images"] as List).map((e) => RoomImage.fromJson(e)).toList();
    facilities = json["facilities"] == null
        ? null
        : (json["facilities"] as List).map((e) => Facility.fromJson(e)).toList();
    bedType = json["bed_type"] == null ? null : BedType.fromJson(json["bed_type"]);
    roomType = json["room_type"] == null ? null : RoomType.fromJson(json["room_type"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["extra_price_per_adult"] = extraPricePerAdult;
    data["extra_price_per_child_bed"] = extraPricePerChildBed;
    data["vat_percentage"] = vatPercentage;
    data["service_charge"] = serviceCharge;
    data["manager_id"] = managerId;
    data["property_id"] = propertyId;
    data["room_type_id"] = roomTypeId;
    data["bed_type_id"] = bedTypeId;
    data["room_name"] = roomName;
    data["room_price_per_night"] = roomPricePerNight;
    data["capacity_of_adults"] = capacityOfAdults;
    data["capacity_of_children"] = capacityOfChildren;
    data["room_size"] = roomSize;
    data["room_description"] = roomDescription;
    data["number_of_room"] = numberOfRoom;
    data["video"] = video;
    data["status"] = status;
    data["booked"] = booked;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    if (roomImages != null) {
      data["room_images"] = roomImages?.map((e) => e.toJson()).toList();
    }
    if (facilities != null) {
      data["facilities"] = facilities?.map((e) => e.toJson()).toList();
    }
    if (bedType != null) {
      data["bed_type"] = bedType?.toJson();
    }
    if (roomType != null) {
      data["room_type"] = roomType?.toJson();
    }
    return data;
  }
}

class RoomImage {
  int? id;
  int? propertyRoomId;
  String? photoName;
  String? createdAt;
  String? updatedAt;

  RoomImage({
    this.id,
    this.propertyRoomId,
    this.photoName,
    this.createdAt,
    this.updatedAt,
  });

  RoomImage.fromJson(Map<String, dynamic> json) {
    id = parseInt(json["id"]);
    propertyRoomId = parseInt(json["property_room_id"]);
    photoName = parseString(json["photo_name"]);
    createdAt = parseString(json["created_at"]);
    updatedAt = parseString(json["updated_at"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["property_room_id"] = propertyRoomId;
    data["photo_name"] = photoName;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    return data;
  }
}

class Facility {
  int? id;
  String? name;
  String? iconClass;
  String? facilityPhoto;
  String? createdAt;
  String? updatedAt;

  Facility({
    this.id,
    this.name,
    this.iconClass,
    this.facilityPhoto,
    this.createdAt,
    this.updatedAt,
  });

  Facility.fromJson(Map<String, dynamic> json) {
    id = parseInt(json["id"]);
    name = parseString(json["name"]);
    iconClass = parseString(json["icon_class"]);
    facilityPhoto = parseString(json["facility_photo"]);
    createdAt = parseString(json["created_at"]);
    updatedAt = parseString(json["updated_at"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["icon_class"] = iconClass;
    data["facility_photo"] = facilityPhoto;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    return data;
  }
}

class BedType {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  BedType({this.id, this.name, this.createdAt, this.updatedAt});

  BedType.fromJson(Map<String, dynamic> json) {
    id = parseInt(json["id"]);
    name = parseString(json["name"]);
    createdAt = parseString(json["created_at"]);
    updatedAt = parseString(json["updated_at"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    return data;
  }
}

class RoomType {
  int? id;
  String? name;

  RoomType({this.id, this.name});

  RoomType.fromJson(Map<String, dynamic> json) {
    id = parseInt(json["id"]);
    name = parseString(json["name"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    return data;
  }
}