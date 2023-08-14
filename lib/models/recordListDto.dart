class RecordListDto {
  RecordListDto(
      {required this.id,
      required this.itemName,
      required this.itemType,
      required this.itemStat,
      required this.itemAmt,
      required this.updatedAt,
      required this.createdAt,
      required this.desc,
      required this.vendorName});

  int? id;
  String? itemName;
  String? itemType;
  String? itemStat;
  int? itemAmt;
  String? updatedAt;
  String? createdAt;
  String? desc;
  String? vendorName;

  factory RecordListDto.fromJson(Map<String, dynamic> json) => RecordListDto(
      id: json['id'],
      itemName: json['item_name'],
      itemStat: json['item_stat'],
      itemType: json['item_type'],
      itemAmt: json['item_amt'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      desc: json['desc'],
      vendorName: json['vendor_name']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "item_name": itemName,
        "item_type": itemType,
        "item_stat": itemStat,
        "item_amt": itemAmt,
        "updated_at": updatedAt,
        "created_at": createdAt,
        "desc": desc,
        "vendor_name": vendorName
      };
}
