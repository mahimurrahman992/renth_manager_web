class ChatListModel {
  ChatListModel({
    required this.message,
    required this.users,
  });

  final String? message;
  final List<Users> users;

  factory ChatListModel.fromJson(Map<String, dynamic> json){
    return ChatListModel(
      message: json["message"],
      users: json["users"] == null ? [] : List<Users>.from(json["users"]!.map((x) => Users.fromJson(x))),
    );
  }

}

class Users {
  Users({
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
  final String? phone;
  final dynamic passresetToken;
  final String? profilePhoto;
  final dynamic birthday;
  final dynamic gender;
  final String? address;
  final dynamic emailVerifiedAt;
  final dynamic profileFor;
  final int? activeStatus;
  final String? role;
  final String? profileVisibility;
  final String? interestRequestAccess;
  final int? status;
  final String? type;
  final int? propertyCategoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Users.fromJson(Map<String, dynamic> json){
    return Users(
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

