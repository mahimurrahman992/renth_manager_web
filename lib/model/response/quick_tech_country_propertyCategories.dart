import 'package:renth_manager/consts/consts.dart';

class QuicktechCountryProperyCatgResponse {
    String? message;
    List<Countries>? countries;
    List<PropertyCategories>? propertyCategories;

    QuicktechCountryProperyCatgResponse({this.message, this.countries, this.propertyCategories});

    QuicktechCountryProperyCatgResponse.fromJson(Map<String, dynamic> json) {
        message = parseString(json["message"]);
        countries = json["countries"] == null ? null : (json["countries"] as List).map((e) => Countries.fromJson(e)).toList();
        propertyCategories = json["property_categories"] == null ? null : (json["property_categories"] as List).map((e) => PropertyCategories.fromJson(e)).toList();
    }

    static List<QuicktechCountryProperyCatgResponse> fromList(List<Map<String, dynamic>> list) {
        return list.map(QuicktechCountryProperyCatgResponse.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data["message"] = message;
        if(countries != null) {
            data["countries"] = countries?.map((e) => e.toJson()).toList();
        }
        if(propertyCategories != null) {
            data["property_categories"] = propertyCategories?.map((e) => e.toJson()).toList();
        }
        return data;
    }
}

class PropertyCategories {
    int? id;
    String? name;
    String? categoryPhoto;

    PropertyCategories({this.id, this.name, this.categoryPhoto});

    PropertyCategories.fromJson(Map<String, dynamic> json) {
        id = parseInt(json["id"]);
        name = parseString(json["name"]);
        categoryPhoto = parseString(json["category_photo"]);
    }

    static List<PropertyCategories> fromList(List<Map<String, dynamic>> list) {
        return list.map(PropertyCategories.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data["id"] = id;
        data["name"] = name;
        data["category_photo"] = categoryPhoto;
        return data;
    }
}

class Countries {
    int? id;
    String? name;
    String? code;

    Countries({this.id, this.name, this.code});

    Countries.fromJson(Map<String, dynamic> json) {
        id = parseInt(json["id"]);
        name = parseString(json["name"]);
        code = parseString(json["code"]);
    }

    static List<Countries> fromList(List<Map<String, dynamic>> list) {
        return list.map(Countries.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data["id"] = id;
        data["name"] = name;
        data["code"] = code;
        return data;
    }
}