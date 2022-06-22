import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(includeIfNull: false)
  final String? id;
  final String name;
  final String surname;
  final UserRole role;

  User(this.id, this.name, this.surname, this.role);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return "$surname $name";
  }
}

enum UserRole {
  @JsonValue('Admin')
  admin,
  @JsonValue('Employee')
  employee
}
