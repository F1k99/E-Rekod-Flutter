import 'dart:convert';

UserDto userDtoFromJson(String str) => UserDto.fromJson(json.decode(str));

String userDtoToJson(UserDto data) => json.encode(data.toJson());

class UserDto {
  UserDto({
    this.id,
    this.name,
    this.email,
    this.createdat,
    this.updatedat,
  });

  int? id;
  String? name;
  String? email;
  DateTime? createdat;
  DateTime? updatedat;

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        createdat: json["created_at"],
        updatedat: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "created_at": createdat,
        "updated_at": updatedat
      };
}
