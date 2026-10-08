import 'package:renth_manager/consts/consts.dart';

class DistrictModel {
  final String? message;
  final List<Districts>? districts;

  DistrictModel({
    this.message,
    this.districts,
  });

  DistrictModel.fromJson(Map<String, dynamic> json)
      : message = parseString(json['message']),
        districts = (json['districts'] as List<dynamic>?)
            ?.map((e) => Districts.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'message': message,
        'districts': districts?.map((e) => e.toJson()).toList()
      };
}

class Districts {
  final int? id;
  final String? divisionId;
  final String? name;
  final String? bnName;
  final String? lat;
  final String? lon;
  final String? url;

  Districts({
    this.id,
    this.divisionId,
    this.name,
    this.bnName,
    this.lat,
    this.lon,
    this.url,
  });

  Districts.fromJson(Map<String, dynamic> json)
      : id = parseInt(json['id']),
        divisionId = parseString(json['division_id']),
        name = parseString(json['name']),
        bnName = parseString(json['bn_name']),
        lat = parseString(json['lat']),
        lon = parseString(json['lon']),
        url = parseString(json['url']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'division_id': divisionId,
        'name': name,
        'bn_name': bnName,
        'lat': lat,
        'lon': lon,
        'url': url
      };
}