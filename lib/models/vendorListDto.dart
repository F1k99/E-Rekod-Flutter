class VendorListDto {
  VendorListDto(
      {required this.createdAt,
      required this.id,
      required this.updatedAt,
      required this.vendorName});

  String? createdAt;
  int? id;
  String? updatedAt;
  String? vendorName;

  factory VendorListDto.fromJson(Map<String, dynamic> json) => VendorListDto(
        createdAt: json['created_at'],
        id: json['id'],
        updatedAt: json['updated_at'],
        vendorName: json['vendor_name'],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "id": id,
        "updated_at": updatedAt,
        "vendor_name": vendorName
      };
}
