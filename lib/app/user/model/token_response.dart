
import 'package:json_annotation/json_annotation.dart';

part 'token_response.g.dart';

@JsonSerializable()
class TokenResponse {

  final String accessToken;
  final String authorizationType;
  final String grantType;
  final int accessTokenExpiresIn;

  TokenResponse({
    required this.accessToken,
    required this.authorizationType,
    required this.grantType,
    required this.accessTokenExpiresIn
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json)
  => _$TokenResponseFromJson(json);
}