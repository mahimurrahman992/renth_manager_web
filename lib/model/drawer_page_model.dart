class DrawerPageModel {
  DrawerPageModel({
    this.message,
    this.socialMedia,
    this.generalSetting,
    this.pages,
  });

  final String? message;
  final List<SocialMedia>? socialMedia;
  final GeneralSetting? generalSetting;
  final List<Pages>? pages;

  factory DrawerPageModel.fromJson(Map<String, dynamic> json) {
    return DrawerPageModel(
      message: json["message"],
      socialMedia:
          json["social_media"] == null
              ? []
              : List<SocialMedia>.from(
                json["social_media"]!.map((x) => SocialMedia.fromJson(x)),
              ),
      generalSetting:
          json["general_setting"] == null
              ? null
              : GeneralSetting.fromJson(json["general_setting"]),
      pages:
          json["pages"] == null
              ? []
              : List<Pages>.from(json["pages"]!.map((x) => Pages.fromJson(x))),
    );
  }
}

class GeneralSetting {
  GeneralSetting({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.description,
    required this.logo,
    required this.favicon,
    required this.fbLink,
    required this.linkedinLink,
    required this.xLink,
    required this.youtubeLink,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? description;
  final String? logo;
  final String? favicon;
  final String? fbLink;
  final dynamic linkedinLink;
  final dynamic xLink;
  final dynamic youtubeLink;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory GeneralSetting.fromJson(Map<String, dynamic> json) {
    return GeneralSetting(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      address: json["address"],
      description: json["description"],
      logo: json["logo"],
      favicon: json["favicon"],
      fbLink: json["fb_link"],
      linkedinLink: json["linkedin_link"],
      xLink: json["x_link"],
      youtubeLink: json["youtube_link"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }
}

class Pages {
  Pages({
    required this.id,
    required this.pageName,
    required this.slug,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? pageName;
  final String? slug;
  final String? description;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Pages.fromJson(Map<String, dynamic> json) {
    return Pages(
      id: json["id"],
      pageName: json["page_name"],
      slug: json["slug"],
      description: json["description"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }
}

class SocialMedia {
  SocialMedia({
    required this.id,
    required this.link,
    required this.icon,
    required this.iconImage,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? link;
  final String? icon;
  final String? iconImage;
  final dynamic createdAt;
  final dynamic updatedAt;

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      id: json["id"],
      link: json["link"],
      iconImage: json['icon_image'],
      icon: json["icon"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }
}
