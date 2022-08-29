import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'token.g.dart';

@JsonSerializable()
class Token {
  final String token;

  Token(this.token);

  bool get isExpired {
    return JwtDecoder.isExpired(token);
  }

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  Map<String, dynamic> toJson() => _$TokenToJson(this);

  String get headerValue => 'Bearer $token';
}
