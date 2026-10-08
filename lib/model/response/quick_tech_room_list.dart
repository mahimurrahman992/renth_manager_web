import 'package:renth_manager/consts/consts.dart';

class QuicktechRoomList {
  String? message;
  List<PropertyRoomRecords>? propertyRoomRecords;

  QuicktechRoomList({this.message, this.propertyRoomRecords});

  QuicktechRoomList.fromJson(Map<String, dynamic> json) {
    message = parseString(json["message"]);
    propertyRoomRecords = json["property_room_records"] == null
        ? null
        : (json["property_room_records"] as List)
            .map((e) => PropertyRoomRecords.fromJson(e))
            .toList();
  }

  static List<QuicktechRoomList> fromList(List<Map<String, dynamic>> list) {
    return list.map(QuicktechRoomList.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["message"] = message;
    if (propertyRoomRecords != null) {
      data["property_room_records"] =
          propertyRoomRecords?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class PropertyRoomRecords {
  int? id;
  int? propertyId;
  int? roomTypeId;
  int? managerId;
  int? totalRoom;
  int? bookedRoom;
  int? availableRoom;
  String? status;
  String? createdAt;
  String? updatedAt;
  PropertyRoom? propertyRoom;
  RoomType? roomType;

  PropertyRoomRecords({
    this.id,
    this.propertyId,
    this.roomTypeId,
    this.managerId,
    this.totalRoom,
    this.bookedRoom,
    this.availableRoom,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.propertyRoom,
    this.roomType,
  });

  PropertyRoomRecords.fromJson(Map<String, dynamic> json) {
    id = parseInt(json["id"]);
    propertyId = parseInt(json["property_id"]);
    roomTypeId = parseInt(json["room_type_id"]);
    managerId = parseInt(json["manager_id"]);
    totalRoom = parseInt(json["total_room"]);
    bookedRoom = parseInt(json["booked_room"]);
    availableRoom = parseInt(json["available_room"]);
    status = parseString(json["status"]);
    createdAt = parseString(json["created_at"]);
    updatedAt = parseString(json["updated_at"]);
    propertyRoom = json["property_room"] == null
        ? null
        : PropertyRoom.fromJson(json["property_room"]);
    roomType =
        json["room_type"] == null ? null : RoomType.fromJson(json["room_type"]);
  }

  static List<PropertyRoomRecords> fromList(List<Map<String, dynamic>> list) {
    return list.map(PropertyRoomRecords.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["property_id"] = propertyId;
    data["room_type_id"] = roomTypeId;
    data["manager_id"] = managerId;
    data["total_room"] = totalRoom;
    data["booked_room"] = bookedRoom;
    data["available_room"] = availableRoom;
    data["status"] = status;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    if (propertyRoom != null) {
      data["property_room"] = propertyRoom?.toJson();
    }
    if (roomType != null) {
      data["room_type"] = roomType?.toJson();
    }
    return data;
  }
}

class PropertyRoom {
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
  String? video;
  int? status;
  dynamic checkOut;
  String? createdAt;
  String? updatedAt;

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
  });

  PropertyRoom.fromJson(Map<String, dynamic> json) {
    id = parseInt(json["id"]);
    discountPricePerNight = parseString(json["discount_price_per_night"]);
    extraMattressPricePerNight =
        parseString(json["extra_mattress_price_per_night"]);
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
    checkOut = json["check_out"];
    createdAt = parseString(json["created_at"]);
    updatedAt = parseString(json["updated_at"]);
  }

  static List<PropertyRoom> fromList(List<Map<String, dynamic>> list) {
    return list.map(PropertyRoom.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["discount_price_per_night"] = discountPricePerNight;
    data["extra_mattress_price_per_night"] = extraMattressPricePerNight;
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
    data["check_out"] = checkOut;
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

  static List<RoomType> fromList(List<Map<String, dynamic>> list) {
    return list.map(RoomType.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    return data;
  }
}