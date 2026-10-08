import 'package:renth_manager/consts/consts.dart';

class DashboardModel {
  DashboardModel({
    this.message,
    this.availableBalance,
    this.totalRevenue,
    this.totalBooking,
    this.totalRoom,
    this.availableRoom,
    this.occupancyRate,
    this.bookings,
    this.roomTypes,
  });

  final String? message;
  final String? availableBalance;
  final String? totalRevenue;
  final int? totalBooking;
  final String? totalRoom;
  final String? availableRoom;
  final int? occupancyRate;
  final Bookings? bookings;
  final List<RoomType>? roomTypes;

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      message: parseString(json["message"]),
      availableBalance: parseString(json["available_balance"]),
      totalRevenue: parseString(json["total_revenue"]),
      totalBooking: parseInt(json["total_booking"]),
      totalRoom: parseString(json["total_room"]),
      availableRoom: parseString(json["available_room"]),
      occupancyRate: parseInt(json["occupancy_rate"]),
      bookings:
          json["bookings"] == null ? null : Bookings.fromJson(json["bookings"]),
      roomTypes: json["room_types"] == null
          ? []
          : List<RoomType>.from(
              json["room_types"]!.map((x) => RoomType.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "total_revenue": totalRevenue,
        "total_booking": totalBooking,
        "total_room": totalRoom,
        "available_room": availableRoom,
        "occupancy_rate": occupancyRate,
        "bookings": bookings?.toJson(),
        "room_types": roomTypes?.map((x) => x.toJson()).toList(),
      };
}

class Bookings {
  Bookings({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  final int? currentPage;
  final List<Datum> data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link> links;
  final dynamic nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  factory Bookings.fromJson(Map<String, dynamic> json) {
    return Bookings(
      currentPage: parseInt(json["current_page"]),
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      firstPageUrl: parseString(json["first_page_url"]),
      from: parseInt(json["from"]),
      lastPage: parseInt(json["last_page"]),
      lastPageUrl: parseString(json["last_page_url"]),
      links: json["links"] == null
          ? []
          : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
      nextPageUrl: json["next_page_url"],
      path: parseString(json["path"]),
      perPage: parseInt(json["per_page"]),
      prevPageUrl: json["prev_page_url"],
      to: parseInt(json["to"]),
      total: parseInt(json["total"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data.map((x) => x.toJson()).toList(),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links.map((x) => x.toJson()).toList(),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  Datum({
    required this.id,
    required this.invoiceNo,
    required this.customerId,
    required this.roomTypeId,
    required this.checkInStart,
    required this.checkOutEnd,
    required this.grandTotal,
    required this.status,
    required this.customer,
    required this.roomType,
  });

  final int? id;
  final String? invoiceNo;
  final int? customerId;
  final int? roomTypeId;
  final DateTime? checkInStart;
  final DateTime? checkOutEnd;
  final String? grandTotal;
  final String? status;
  final RoomType? customer;
  final RoomType? roomType;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: parseInt(json["id"]),
      invoiceNo: parseString(json["invoice_no"]),
      customerId: parseInt(json["customer_id"]),
      roomTypeId: parseInt(json["room_type_id"]),
      checkInStart: DateTime.tryParse(json["check_in_start"] ?? ""),
      checkOutEnd: DateTime.tryParse(json["check_out_end"] ?? ""),
      grandTotal: parseString(json["grand_total"]),
      status: parseString(json["status"]),
      customer: json["customer"] == null
          ? null
          : RoomType.fromJson(json["customer"]),
      roomType: json["room_type"] == null
          ? null
          : RoomType.fromJson(json["room_type"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_no": invoiceNo,
        "customer_id": customerId,
        "room_type_id": roomTypeId,
        "check_in_start": checkInStart?.toIso8601String(),
        "check_out_end": checkOutEnd?.toIso8601String(),
        "grand_total": grandTotal,
        "status": status,
        "customer": customer?.toJson(),
        "room_type": roomType?.toJson(),
      };
}

class RoomType {
  RoomType({
    required this.id,
    required this.name,
  });

  final int? id;
  final String? name;

  factory RoomType.fromJson(Map<String, dynamic> json) {
    return RoomType(
      id: parseInt(json["id"]),
      name: parseString(json["name"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Link {
  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  final String? url;
  final String? label;
  final bool? active;

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: parseString(json["url"]),
      label: parseString(json["label"]),
      active: parseBool(json["active"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
