class UserListDto {
  UserListDto(
      {required this.id,
      required this.createdAt,
      required this.email,
      required this.name,
      required this.role});

  int? id;
  String? createdAt;
  String? email;
  String? name;
  String? role;

  factory UserListDto.fromJson(Map<String, dynamic> json) => UserListDto(
      createdAt: json['created_at'],
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role']);

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "id": id,
        "name": name,
        "email": email,
        "role": role
      };
}
