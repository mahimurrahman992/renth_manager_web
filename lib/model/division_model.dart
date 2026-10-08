import 'package:renth_manager/consts/consts.dart';

class DivisionModel {
  final String? message;
  final List<Divisions>? divisions;

  DivisionModel({
    this.message,
    this.divisions,
  });

  DivisionModel.fromJson(Map<String, dynamic> json)
      : message = parseString(json['message']),
        divisions = (json['divisions'] as List<dynamic>?)
            ?.map((e) => Divisions.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'message': message,
        'divisions': divisions?.map((e) => e.toJson()).toList()
      };
}

class Divisions {
  final int? id;
  final String? name;
  final String? countryId;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  Divisions({
    this.id,
    this.name,
    this.countryId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Divisions.fromJson(Map<String, dynamic> json)
      : id = parseInt(json['id']),
        name = parseString(json['name']),
        countryId = parseString(json['country_id']),
        status = parseString(json['status']),
        createdAt = parseString(json['created_at']),
        updatedAt = parseString(json['updated_at']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'country_id': countryId,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}