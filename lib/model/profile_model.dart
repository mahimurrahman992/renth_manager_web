import 'package:renth_manager/consts/consts.dart';

class ProfileModel {
  final User? user;

  ProfileModel({this.user});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
    };
  }
}

class User {
  final int? id;
  final String? country;
  final String? name;
  final String? slug;
  final String? email;
  final String? phone;
  final int? passresetToken;
  final String? profilePhoto;
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
  final String? createdAt;
  final String? updatedAt;

  User({
    this.id,
    this.country,
    this.name,
    this.slug,
    this.email,
    this.phone,
    this.passresetToken,
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: parseInt(json['id']),
      country: parseString(json['country']),
      name: parseString(json['name']),
      slug: parseString(json['slug']),
      email: parseString(json['email']),
      phone: parseString(json['phone']),
      passresetToken: parseInt(json['passresetToken']),
      profilePhoto: parseString(json['profile_photo']),
      birthday: json['birthday'],
      gender: json['gender'],
      address: json['address'],
      emailVerifiedAt: json['email_verified_at'],
      profileFor: json['profile_for'],
      activeStatus: parseInt(json['active_status']),
      role: parseString(json['role']),
      profileVisibility: parseString(json['profile_visibility']),
      interestRequestAccess: parseString(json['interest_request_access']),
      status: parseInt(json['status']),
      type: json['type'],
      propertyCategoryId: parseInt(json['property_category_id']),
      createdAt: parseString(json['created_at']),
      updatedAt: parseString(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country': country,
      'name': name,
      'slug': slug,
      'email': email,
      'phone': phone,
      'passresetToken': passresetToken,
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
      'updated_at': updatedAt,
    };
  }
}