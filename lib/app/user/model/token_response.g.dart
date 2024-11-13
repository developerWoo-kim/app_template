// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenResponse _$TokenResponseFromJson(Map<String, dynamic> json) =>
    TokenResponse(
      accessToken: json['accessToken'] as String,
      authorizationType: json['authorizationType'] as String,
      grantType: json['grantType'] as String,
      accessTokenExpiresIn: (json['accessTokenExpiresIn'] as num).toInt(),
    );

Map<String, dynamic> _$TokenResponseToJson(TokenResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'authorizationType': instance.authorizationType,
      'grantType': instance.grantType,
      'accessTokenExpiresIn': instance.accessTokenExpiresIn,
    };
