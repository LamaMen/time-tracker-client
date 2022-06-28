import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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

  factory User.fromToken(String token) {
    final jwtData = JwtDecoder.decode(token);
    return User.fromJson(jwtData);
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return "$surname $name";
  }
}

enum UserRole {
  @JsonValue('Admin')
  admin(1),
  @JsonValue('Employee')
  employee(2);

  final int privacy;

  const UserRole(this.privacy);

  bool isCanAccess(UserRole another) {
    return another.privacy >= privacy;
  }
}