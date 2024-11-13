
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';


@JsonSerializable()
class LoginResponse {
  final String grantType;
  final String authorizationType;
  final String accessToken;
  final String refreshToken;
  final int accessTokenExpiresIn;

  LoginResponse({
    required this.grantType,
    required this.authorizationType,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresIn
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json)
  => _$LoginResponseFromJson(json);

}