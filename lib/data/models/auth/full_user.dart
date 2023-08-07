import 'package:json_annotation/json_annotation.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';

part 'full_user.g.dart';

@JsonSerializable()
class FullUser extends User {
  final String password;

  FullUser(super.id, super.name, super.surname, this.password, super.role);

  factory FullUser.initial() {
    return FullUser('', '', '', '', UserRole.employee);
  }

  factory FullUser.fromJson(Map<String, dynamic> json) => _$FullUserFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FullUserToJson(this);

  @override
  String toString() {
    return "$surname $name";
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (other is! User) return false;
    return other.id == id;
  }
}
