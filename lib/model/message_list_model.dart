class MessageListModel {
  MessageListModel({
    required this.messages,
  });

  final List<Messages> messages;

  factory MessageListModel.fromJson(Map<String, dynamic> json){
    return MessageListModel(
      messages: json["messages"] == null ? [] : List<Messages>.from(json["messages"]!.map((x) => Messages.fromJson(x))),
    );
  }

}

class Messages {
  Messages({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.msg,
    required this.createdAt,
    required this.updatedAt,
    required this.receiver,
  });

  final int? id;
  final int? senderId;
  final int? receiverId;
  final String? msg;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Receiver? receiver;

  factory Messages.fromJson(Map<String, dynamic> json){
    return Messages(
      id: json["id"],
      senderId: json["sender_id"],
      receiverId: json["receiver_id"],
      msg: json["msg"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      receiver: json["receiver"] == null ? null : Receiver.fromJson(json["receiver"]),
    );
  }

}

class Receiver {
  Receiver({
    required this.id,
    required this.country,
    required this.name,
    required this.slug,
    required this.email,
    required this.phone,
    required this.passresetToken,
    required this.profilePhoto,
    required this.birthday,
    required this.gender,
    required this.address,
    required this.emailVerifiedAt,
    required this.profileFor,
    required this.activeStatus,
    required this.role,
    required this.profileVisibility,
    required this.interestRequestAccess,
    required this.status,
    required this.type,
    required this.propertyCategoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final dynamic country;
  final String? name;
  final String? slug;
  final String? email;
  final dynamic phone;
  final dynamic passresetToken;
  final dynamic profilePhoto;
  final dynamic birthday;
  final dynamic gender;
  final dynamic address;
  final dynamic emailVerifiedAt;
  final dynamic profileFor;
  final int? activeStatus;
  final String? role;
  final String? profileVisibility;
  final String? interestRequestAccess;
  final int? status;
  final dynamic type;
  final int? propertyCategoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Receiver.fromJson(Map<String, dynamic> json){
    return Receiver(
      id: json["id"],
      country: json["country"],
      name: json["name"],
      slug: json["slug"],
      email: json["email"],
      phone: json["phone"],
      passresetToken: json["passresetToken"],
      profilePhoto: json["profile_photo"],
      birthday: json["birthday"],
      gender: json["gender"],
      address: json["address"],
      emailVerifiedAt: json["email_verified_at"],
      profileFor: json["profile_for"],
      activeStatus: json["active_status"],
      role: json["role"],
      profileVisibility: json["profile_visibility"],
      interestRequestAccess: json["interest_request_access"],
      status: json["status"],
      type: json["type"],
      propertyCategoryId: json["property_category_id"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

}
