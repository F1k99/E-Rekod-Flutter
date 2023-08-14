class CategoryListDto {
  CategoryListDto(
      {required this.createdAt,
      required this.id,
      required this.itemName,
      required this.itemStat,
      required this.updatedAt});

  String? createdAt;
  int? id;
  String? itemName;
  String? itemStat;
  String? updatedAt;

  factory CategoryListDto.fromJson(Map<String, dynamic> json) =>
      CategoryListDto(
        createdAt: json['created_at'],
        id: json['id'],
        itemName: json['item_name'],
        itemStat: json['item_stat'],
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "id": id,
        "item_name": itemName,
        "item_stat": itemStat,
        "updated_at": updatedAt,
      };
}
