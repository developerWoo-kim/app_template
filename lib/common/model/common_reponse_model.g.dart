// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_reponse_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommonResponseModel _$CommonResponseModelFromJson(Map<String, dynamic> json) =>
    CommonResponseModel(
      status: json['status'] as String,
      message: json['message'] as String,
      body: json['body'],
    );

Map<String, dynamic> _$CommonResponseModelToJson(
        CommonResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'body': instance.body,
    };
