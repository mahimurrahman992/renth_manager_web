// import 'package:renth_manager/consts/consts.dart';

// class PropertyCategoryModel {
//   final String? message;
//   final List<PropertyCategories>? propertyCategories;

//   PropertyCategoryModel({
//     this.message,
//     this.propertyCategories,
//   });

//   PropertyCategoryModel.fromJson(Map<String, dynamic> json)
//       : message = parseString(json['message']),
//         propertyCategories = (json['property_categories'] as List<dynamic>?)
//             ?.map((e) => PropertyCategories.fromJson(e as Map<String, dynamic>))
//             .toList();

//   Map<String, dynamic> toJson() => {
//         'message': message,
//         'property_categories': propertyCategories?.map((e) => e.toJson()).toList()
//       };
// }

// class PropertyCategories {
//   final int? id;
//   final String? name;
//   final String? categoryPhoto;
//   final String? platformFee;
//   final String? createdAt;
//   final String? updatedAt;

//   PropertyCategories({
//     this.id,
//     this.name,
//     this.categoryPhoto,
//     this.platformFee,
//     this.createdAt,
//     this.updatedAt,
//   });

//   PropertyCategories.fromJson(Map<String, dynamic> json)
//       : id = parseInt(json['id']),
//         name = parseString(json['name']),
//         categoryPhoto = parseString(json['category_photo']),
//         platformFee = parseString(json['platform_fee']),
//         createdAt = parseString(json['created_at']),
//         updatedAt = parseString(json['updated_at']);

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'category_photo': categoryPhoto,
//         'platform_fee': platformFee,
//         'created_at': createdAt,
//         'updated_at': updatedAt
//       };
// }