class QuickTechCreateRoomRequest {
  final int propertyId;
  final int roomTypeId;
  final int bedTypeId;
  final String roomName;
  final String roomPricePerNight;
  final String capacityOfAdults;
  final String capacityOfChildren;
  final String roomSize;
  final String roomDescription;
  final String numberOfRoom;

  final List<String> imagesPaths;
  final String? videoPath;
  final List<int>? facilityIds;

  final String? extraPricePerAdult;
  final String? extraPricePerChild;
  final String? vatPercentage;
  final String? serviceCharge;

  // Missing fields added
  final String? discountPricePerNight;
  final String? extraMattressPricePerNight;

  QuickTechCreateRoomRequest({
    required this.propertyId,
    required this.roomTypeId,
    required this.bedTypeId,
    required this.roomName,
    required this.roomPricePerNight,
    required this.capacityOfAdults,
    required this.capacityOfChildren,
    required this.roomSize,
    required this.roomDescription,
    required this.numberOfRoom,
    required this.imagesPaths,
    this.videoPath,
    this.facilityIds,
    this.extraPricePerAdult,
    this.extraPricePerChild,
    this.vatPercentage,
    this.serviceCharge,
    this.discountPricePerNight,
    this.extraMattressPricePerNight,
  });

  Map<String, String> toFormFields() {
    return {
      'property_id': propertyId.toString(),
      'room_type_id': roomTypeId.toString(),
      'bed_type_id': bedTypeId.toString(),
      'room_name': roomName,
      'room_price_per_night': roomPricePerNight,
      'capacity_of_adults': capacityOfAdults,
      'capacity_of_children': capacityOfChildren,
      'room_size': roomSize,
      'room_description': roomDescription,
      'number_of_room': numberOfRoom,

      'extra_price_per_adult':
      (extraPricePerAdult?.isEmpty ?? true) ? '0' : extraPricePerAdult!,

      'extra_price_per_child_bed':
      (extraPricePerChild?.isEmpty ?? true) ? '0' : extraPricePerChild!,

      'vat_percentage':
      (vatPercentage?.isEmpty ?? true) ? '0' : vatPercentage!,

      'service_charge':
      (serviceCharge?.isEmpty ?? true) ? '0' : serviceCharge!,

      // Added fields
      'discount_price_per_night':
      (discountPricePerNight?.isEmpty ?? true)
          ? '0'
          : discountPricePerNight!,

      'extra_mattress_price_per_night':
      (extraMattressPricePerNight?.isEmpty ?? true)
          ? '0'
          : extraMattressPricePerNight!,
    };
  }
}