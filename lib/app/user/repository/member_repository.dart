import 'package:app_template/app/user/model/user_model.dart';
import 'package:app_template/common/const/data.dart';
import 'package:app_template/common/dio/dio.dart';
import 'package:app_template/common/model/common_reponse_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';

part 'member_repository.g.dart';

final memberRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  final repository = MemberRepository(dio, baseUrl: '$ip/api/v1/user');
  return repository;
});


@RestApi()
abstract class MemberRepository {
  factory MemberRepository(Dio dio, {String baseUrl})
  = _MemberRepository;

  @GET('/id-duple-check/{id}')
  Future<CommonResponseModel> idDuplicationCheck({@Path() required String id});


  @POST('/join')
  Future<CommonResponseModel> joinUser(@Body() FormData formData);

  @PUT('/password')
  Future<CommonResponseModel> updatePassword(@Body() Map<String, dynamic> json);

  @GET('/by-phoneNum/{phoneNum}')
  Future<CommonResponseModel> findUserIdByPhoneNum({@Path() required String phoneNum});

  @GET('')
  @Headers({
    'accessToken' : 'true'
  })
  Future<UserModel> findUser();

  @PUT('/basic-info')
  @Headers({
    'accessToken' : 'true'
  })
  Future<CommonResponseModel> updateBasicInfo(@Body() Map<String, dynamic> json);

  @PUT('/business-info')
  @Headers({
    'accessToken' : 'true'
  })
  Future<CommonResponseModel> updateBusinessInfo(@Body() Map<String, dynamic> json);

  @PUT('/account-info')
  @Headers({
    'accessToken' : 'true'
  })
  Future<CommonResponseModel> updateAccountInfo(@Body() Map<String, dynamic> json);

  @PUT('/car-info')
  @Headers({
    'accessToken' : 'true'
  })
  Future<CommonResponseModel> updateCarInfo(@Body() FormData data);

  @POST('/tax/agree-sign')
  @Headers({
    'accessToken': 'true'
  })
  Future<CommonResponseModel> saveTaxSignAgree(@Body() FormData data);

  @POST('/wish')
  @Headers({
    'accessToken': 'true'
  })
  Future<void> saveWish({@Query('adSns') String? adSns,});

  @DELETE('/wish/{adSn}')
  @Headers({
    'accessToken': 'true'
  })
  Future<void> deleteWish({@Path() required String adSn});
}