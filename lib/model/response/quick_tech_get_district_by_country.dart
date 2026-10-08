import 'package:renth_manager/consts/consts.dart';

class QuicktechgetdistrictByCountryResponse {
    String? message;
    List<District>? districts;

    QuicktechgetdistrictByCountryResponse({this.message, this.districts});

    QuicktechgetdistrictByCountryResponse.fromJson(Map<String, dynamic> json) {
        message = parseString(json["message"]);
        districts = json["districts"] == null ? null : (json["districts"] as List).map((e) => District.fromJson(e)).toList();
    }

    static List<QuicktechgetdistrictByCountryResponse> fromList(List<Map<String, dynamic>> list) {
        return list.map(QuicktechgetdistrictByCountryResponse.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data["message"] = message;
        if(districts != null) {
            data["districts"] = districts?.map((e) => e.toJson()).toList();
        }
        return data;
    }
}

class District {
    int? id;
    int? countryId;
    String? name;

    District({this.id, this.countryId, this.name});

    District.fromJson(Map<String, dynamic> json) {
        id = parseInt(json["id"]);
        countryId = parseInt(json["country_id"]);
        name = parseString(json["name"]);
    }

    static List<District> fromList(List<Map<String, dynamic>> list) {
        return list.map(District.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data["id"] = id;
        data["country_id"] = countryId;
        data["name"] = name;
        return data;
    }
}