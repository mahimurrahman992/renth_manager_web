class WithdrawReqModel {
  WithdrawReqModel({
    required this.managerWallets,
  });

  final ManagerWallets? managerWallets;

  factory WithdrawReqModel.fromJson(Map<String, dynamic> json){
    return WithdrawReqModel(
      managerWallets: json["manager_wallets"] == null ? null : ManagerWallets.fromJson(json["manager_wallets"]),
    );
  }

}

class ManagerWallets {
  ManagerWallets({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  final int? currentPage;
  final List<Datum> data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link> links;
  final dynamic nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  factory ManagerWallets.fromJson(Map<String, dynamic> json){
    return ManagerWallets(
      currentPage: json["current_page"],
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      firstPageUrl: json["first_page_url"],
      from: json["from"],
      lastPage: json["last_page"],
      lastPageUrl: json["last_page_url"],
      links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
      nextPageUrl: json["next_page_url"],
      path: json["path"],
      perPage: json["per_page"],
      prevPageUrl: json["prev_page_url"],
      to: json["to"],
      total: json["total"],
    );
  }

}

class Datum {
  Datum({
    required this.id,
    required this.paymentType,
    required this.phoneNumber,
    required this.bankName,
    required this.accountHolderName,
    required this.accountNumber,
    required this.branchOrRoutingNumber,
    required this.evidencePhoto,
    required this.managerId,
    required this.subject,
    required this.totalAmount,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.createdAtDhaka,
    required this.updatedAtDhaka,
  });

  final int? id;
  final String? paymentType;
  final String? phoneNumber;
  final String? bankName;
  final String? accountHolderName;
  final String? accountNumber;
  final String? branchOrRoutingNumber;
  final String? evidencePhoto;
  final int? managerId;
  final String? subject;
  final String? totalAmount;
  final String? type;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? createdAtDhaka;
  final String? updatedAtDhaka;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"],
      paymentType: json["payment_type"],
      phoneNumber: json["phone_number"],
      bankName: json["bank_name"],
      accountHolderName: json["account_holder_name"],
      accountNumber: json["account_number"],
      branchOrRoutingNumber: json["branch_or_routing_number"],
      evidencePhoto: json["evidence_photo"],
      managerId: json["manager_id"],
      subject: json["subject"],
      totalAmount: json["total_amount"],
      type: json["type"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      createdAtDhaka: json["created_at_dhaka"],
      updatedAtDhaka: json["updated_at_dhaka"],
    );
  }

}

class Link {
  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  final String? url;
  final String? label;
  final bool? active;

  factory Link.fromJson(Map<String, dynamic> json){
    return Link(
      url: json["url"],
      label: json["label"],
      active: json["active"],
    );
  }

}
