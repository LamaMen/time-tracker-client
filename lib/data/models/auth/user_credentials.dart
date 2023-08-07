import 'package:json_annotation/json_annotation.dart';

part 'user_credentials.g.dart';

@JsonSerializable(createFactory: false)
class UserCredentials {
  final String id;
  final String password;

  UserCredentials(this.id, this.password);

  Map<String, dynamic> toJson() => _$UserCredentialsToJson(this);
}