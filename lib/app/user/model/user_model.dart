import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

abstract class UserModelBase {}

class UserModelLoading extends UserModelBase{}

class UserModelError extends UserModelBase{
  final String message;

  UserModelError({required this.message});
}

@JsonSerializable()
class UserModel extends UserModelBase{
  final String userId;                          // 사용자 아이디
  final String userNm;                          // 사용자명
  final String pswd;                            // 비밀번호
  final String? eml;                             // 이메일
  final String rprsvNm;                         // 대표자명
  final String bzmnNm;                          // 사업자명
  final String bzmnNo;                          // 사업자 번호
  final String? telno;                           // 전화번호
  final String? fxno;                            // 팩스번호
  final String zip;                             // 우편번호
  final String addr;                            // 주소
  final String daddr;                           // 상세주소
  final String bankNm;                          // 은행
  final String dpstrNm;                         // 예금주명
  final String actno;                           // 계좌번호
  final String mainDrivergn;                      // 주 운행지역 코드
  final String? vhclNo;                          // 차량번호
  final String? vhclLoadLen;                  // 차량 적재함 길이
  final String? vhclLoadweight;                  // 차량 적재무게
  final String? vhclType;                        // 차량 종류
  final String? avrDriveBgnghr;                  // 평균 운행 시작시간
  final String? avrDriveEndhr;                   // 평균 운행 종료시간
  // @JsonKey(
  //   fromJson: DataUtils.pathToUrl,
  // )
  final String? leftAtchfile;                    // 좌측 첨부파일
  // @JsonKey(
  //   fromJson: DataUtils.pathToUrl,
  // )
  final String? rightAtchfile;                   // 우측 첨부파일
  // @JsonKey(
  //   fromJson: DataUtils.pathToUrl,
  // )
  final String? backAtchfile;                    // 후방 첨부파일
  // @JsonKey(
  //   fromJson: DataUtils.pathToUrl,
  // )
  final String? pnlAtchfile;                     // 계기판 첨부파일 일련번호
  // @JsonKey(
  //   fromJson: DataUtils.pathToUrl,
  // )
  final String? bzmnrgstrAtchfile;               // 사업자등록증 첨부파일 일련번호
  final String? consigsignAtchfileSn;
  final String aprvYn;                          // 승인여부
  final String? beaconAddress;
  final String? runningAdSn;

  UserModel({
    required this.userId,
    required this.userNm,
    required this.pswd,
    this.eml,
    required this.rprsvNm,
    required this.bzmnNm,
    required this.bzmnNo,
    this.telno,
    this.fxno,
    required this.zip,
    required this.addr,
    required this.daddr,
    required this.bankNm,
    required this.dpstrNm,
    required this.actno,
    required this.mainDrivergn,
    this.avrDriveBgnghr,
    this.avrDriveEndhr,
    this.vhclNo,
    this.vhclLoadLen,
    this.vhclLoadweight,
    this.vhclType,
    this.leftAtchfile,
    this.rightAtchfile,
    this.backAtchfile,
    this.pnlAtchfile,
    this.bzmnrgstrAtchfile,
    this.consigsignAtchfileSn,
    required this.aprvYn,
    this.beaconAddress,
    this.runningAdSn,
  });
  
  UserModel copyWith({
    String? userId,                          // 사용자 아이디
    String? userNm,                          // 사용자명
    String? pswd,                            // 비밀번호
    String? eml,                             // 이메일
    String? rprsvNm,                         // 대표자명
    String? bzmnNm,                          // 사업자명
    String? bzmnNo,                          // 사업자 번호
    String? telno,                           // 전화번호
    String? fxno,                            // 팩스번호
    String? zip,                             // 우편번호
    String? addr,                            // 주소
    String? daddr,                           // 상세주소
    String? bankNm,                          // 은행
    String? dpstrNm,                         // 예금주명
    String? actno,                           // 계좌번호
    String? mainDrivergn,                      // 주 운행지역 코드
    String? vhclNo,                          // 차량번호
    String? vhclLoadLen,
    String? vhclLoadweight,                  // 차량 적재무게
    String? vhclType,                        // 차량 종류
    String? avrDriveBgnghr,                  // 평균 운행 시작시간
    String? avrDriveEndhr,                   // 평균 운행 종료시간
    String? leftAtchfile,                    // 좌측 첨부파일
    String? rightAtchfile,                   // 우측 첨부파일
    String? backAtchfile,                    // 후방 첨부파일
    String? pnlAtchfile,                     // 계기판 첨부파일 일련번호
    String? bzmnrgstrAtchfile,               // 사업자등록증 첨부파일 일련번호
    String? consigsignAtchfileSn,
    String? aprvYn,                          // 승인여부
    String? beaconAddress,
    String? runningAdSn,
  }) {
    return UserModel(
      userId:  userId ?? this.userId,                          // 사용자 아이디
      userNm: userNm ?? this.userNm,                          // 사용자명
      pswd: pswd ?? this.pswd,                            // 비밀번호
      eml: eml ?? this.eml,                             // 이메일
      rprsvNm: rprsvNm ?? this.rprsvNm,                         // 대표자명
      bzmnNm: bzmnNm ?? this.bzmnNo,                          // 사업자명
      bzmnNo: bzmnNo ?? this.bzmnNo,                          // 사업자 번호
      telno: telno ?? this.telno,                           // 전화번호
      fxno: fxno ?? this.fxno,                            // 팩스번호
      zip: zip ?? this.zip,                             // 우편번호
      addr: addr ?? this.addr,                            // 주소
      daddr: daddr ?? this.daddr,                           // 상세주소
      bankNm: bankNm ?? this.bankNm,                          // 은행
      dpstrNm: dpstrNm ?? this.dpstrNm,                         // 예금주명
      actno: actno ?? this.actno,                           // 계좌번호
      mainDrivergn: mainDrivergn ?? this.mainDrivergn,                      // 주 운행지역 코드
      vhclNo: vhclNo ?? this.vhclNo,                          // 차량번호
      vhclLoadLen: vhclLoadLen ?? this.vhclLoadLen,
      vhclLoadweight: vhclLoadweight ?? this.vhclLoadweight,                  // 차량 적재무게
      vhclType: vhclType ?? this.vhclType,                        // 차량 종류
      avrDriveBgnghr: avrDriveBgnghr ?? this.avrDriveBgnghr,                  // 평균 운행 시작시간
      avrDriveEndhr: avrDriveEndhr ?? this.avrDriveEndhr,                   // 평균 운행 종료시간
      leftAtchfile: leftAtchfile ?? this.leftAtchfile,                    // 좌측 첨부파일
      rightAtchfile: rightAtchfile ?? this.rightAtchfile,                   // 우측 첨부파일
      backAtchfile: backAtchfile ?? this.backAtchfile,                    // 후방 첨부파일
      pnlAtchfile: pnlAtchfile ?? this.pnlAtchfile,                     // 계기판 첨부파일 일련번호
      bzmnrgstrAtchfile: bzmnrgstrAtchfile ?? this.bzmnrgstrAtchfile,               // 사업자등록증 첨부파일 일련번호
      consigsignAtchfileSn: consigsignAtchfileSn ?? this.consigsignAtchfileSn,
      aprvYn: aprvYn ?? this.aprvYn,                          // 승인여부
      beaconAddress: beaconAddress ?? this.beaconAddress,
      runningAdSn: runningAdSn ?? this.runningAdSn,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json)
  => _$UserModelFromJson(json);
}