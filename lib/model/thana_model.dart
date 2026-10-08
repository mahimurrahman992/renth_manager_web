import 'package:renth_manager/consts/consts.dart';

class ThanaModel {
  final String? message;
  final List<Upazilas>? upazilas;

  ThanaModel({
    this.message,
    this.upazilas,
  });

  ThanaModel.fromJson(Map<String, dynamic> json)
      : message = parseString(json['message']),
        upazilas = (json['upazilas'] as List<dynamic>?)
            ?.map((e) => Upazilas.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'message': message,
        'upazilas': upazilas?.map((e) => e.toJson()).toList()
      };
}

class Upazilas {
  final int? id;
  final String? districtId;
  final String? name;
  final String? bnName;
  final String? url;
  final dynamic createdAt;
  final dynamic updatedAt;

  Upazilas({
    this.id,
    this.districtId,
    this.name,
    this.bnName,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  Upazilas.fromJson(Map<String, dynamic> json)
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