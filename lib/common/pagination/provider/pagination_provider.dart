import 'package:app_template/common/pagination/model/pagination_id_model.dart';
import 'package:app_template/common/pagination/model/pagination_model.dart';
import 'package:app_template/common/pagination/model/pagination_params.dart';
import 'package:app_template/common/pagination/repository/pagination_repository_interface.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginationProvider<
T extends PaginationIdModel,
U extends PaginationRepositoryInterface<T>
> extends StateNotifier<PaginationBase>{
  final U repository;

  PaginationProvider({
    required this.repository,
  }) : super(PaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 10,
    // true : 추가로 데이터 요청
    // false : 새로고침
    bool fetchMore = false,
    // 강제로 다시 로딩하기
    // true - CursorPaginationLoading()
    bool forceRefetch = false,

    PaginationParams? params,
  }) async{
    try {
      // 5가지 상태
      // 1) CursorPagination - 정상적으로 데이터가 있는 상태
      // 2) CursorPaginationLoading - 데이터가 로딩중인 상태 (캐시 없음)
      // 3) CursorPaginationError - 에러가 있는 상태
      // 4) CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져올때
      // 5) CursorPaginationFetchMore - 추가 데이터를 요청할 때

      // 바로 반환하는 상황
      // 1) hasmore = false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고있다면)
      // 2) loading - fetchMore = true ()
      //    fetchMore가 아닐때 - 새로고침의 의도가 있다.
      if(state is Pagination && !forceRefetch) {
        final pState = state as Pagination;
        if(!pState.hasNextData) {
          return;
        }
      }

      final isLoading = state is PaginationLoading;
      final isRefetching = state is PaginationRefetching;
      final isFetchingMore = state is PaginationFetchingMore;

      // 2번 반환 상황
      if(fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // PaginationParams 생성
      PaginationParams paginationParams = params ?? PaginationParams(count: fetchCount,);

      // fetchingMore - 데이터를 추가로 가져오는 상황
      if(fetchMore) {
        final pState = state as Pagination<T>;

        state = PaginationFetchingMore(
            count: pState.count,
            hasNextData: pState.hasNextData,
            data: pState.data
        );

        paginationParams = paginationParams.copyWith(
            count: pState.count,
            lastId: pState.data.last.id
        );

        // 데이터를 처음부터 가져오는 상황
      } else {
        // 데이터가 있는 상황이면 기존 데이터를 보조한채로 Fetch(API요청)
        if(state is Pagination && !forceRefetch) {
          final pState = state as Pagination<T>;
          state = PaginationRefetching<T>(
              count: pState.count,
              hasNextData: pState.hasNextData,
              data: pState.data
          );

          // 나머지 상황
        } else {
          state = PaginationLoading();
        }
      }

      final resp = await repository.paginate(
          paginationParams: paginationParams
      );

      if(state is PaginationFetchingMore) {
        final pState = state as PaginationFetchingMore<T>;

        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
        //
      } else {
        state = resp;
      }
    } catch(e) {
      if (e is DioError && e.response != null) {
        state = PaginationError(message: '${e.response?.data["message"] ?? e.response?.statusMessage ?? "Unknown error"}');
      } else {
        state = PaginationError(message: '알수없는 에러가 발생하였습니다.');
      }

    }

  }
}