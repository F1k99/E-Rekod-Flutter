import 'dart:convert';

ProfileDto profileDtoFromJson(String str) =>
    ProfileDto.fromJson(json.decode(str));

String profileDtoToJson(ProfileDto data) => json.encode(data.toJson());

class ProfileDto {
  ProfileDto({
    this.id,
    this.name,
    this.email,
    this.role,
    this.createdat,
    this.updatedat,
  });

  int? id;
  String? name;
  String? email;
  String? role;
  String? createdat;
  String? updatedat;

  factory ProfileDto.fromJson(Map<String, dynamic> json) => ProfileDto(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        createdat: json["created_at"],
        updatedat: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "created_at": createdat,
        "updated_at": updatedat
      };
}
