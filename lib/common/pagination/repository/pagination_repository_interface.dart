import 'package:app_template/common/pagination/model/pagination_id_model.dart';
import 'package:app_template/common/pagination/model/pagination_model.dart';
import 'package:app_template/common/pagination/model/pagination_params.dart';

abstract class PaginationRepositoryInterface<T extends PaginationIdModel> {
  Future<Pagination<T>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });
}