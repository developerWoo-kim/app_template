import 'package:json_annotation/json_annotation.dart';

part 'pagination_model.g.dart';

abstract class PaginationBase {}
class PaginationLoading extends PaginationBase {}
class PaginationError extends PaginationBase {
  final String message;

  PaginationError({
    required this.message,
  });
}

@JsonSerializable(
  genericArgumentFactories: true
)
class Pagination<T> extends PaginationBase{
  final int count;
  final bool hasNextData;
  final List<T> data;

  Pagination({
    required this.count,
    required this.hasNextData,
    required this.data
  });

  Pagination copyWith({
    int? count,
    bool? hasNextData,
    List<T>? data,
  }) {
    return Pagination<T>(
        count: count ?? this.count,
        hasNextData: hasNextData ?? this.hasNextData,
        data: data ?? this.data
    );
  }

  factory Pagination.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT)
  => _$PaginationFromJson(json, fromJsonT);

}

// 새로고침 할때
class PaginationRefetching<T> extends Pagination<T>{
  PaginationRefetching({
    required super.count,
    required super.hasNextData,
    required super.data
  });
}
// 리스트의 맨 아래로 내려서 추가 데이터를 요청하는 중일 경우
class PaginationFetchingMore<T> extends Pagination<T>{
  PaginationFetchingMore({
    required super.count,
    required super.hasNextData,
    required super.data
  });
}