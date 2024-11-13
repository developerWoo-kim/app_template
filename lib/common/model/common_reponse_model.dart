import 'package:json_annotation/json_annotation.dart';

part 'common_reponse_model.g.dart';

@JsonSerializable()
class CommonResponseModel{
  final String status;
  final String message;
  final dynamic body;

  CommonResponseModel({
    required this.status,
    required this.message,
    this.body
  });

  factory CommonResponseModel.fromJson(Map<String, dynamic> json)
  => _$CommonResponseModelFromJson(json);
}