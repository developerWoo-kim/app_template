import 'package:json_annotation/json_annotation.dart';

part 'pagination_params.g.dart';

@JsonSerializable()
class PaginationParams {
  final int? count;
  final String? lastId;

  const PaginationParams({
    this.count,
    this.lastId,
  });

  PaginationParams copyWith({
    int? count,
    String? lastId,
  }) {
    return PaginationParams(
      count: count ?? this.count,
      lastId: lastId ?? this.lastId,
    );
  }

  factory PaginationParams.fromJson(Map<String, dynamic> json)
  => _$PaginationParamsFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationParamsToJson(this);
}